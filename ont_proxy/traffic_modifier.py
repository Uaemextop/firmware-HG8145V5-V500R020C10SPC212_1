import re

from . import config


USER_TYPE_PATTERNS = [
    (re.compile(r"(var\s+curUserType\s*=\s*')[^']*(')", re.IGNORECASE), rf"\g<1>{config.TARGET_USER_TYPE}\2"),
    (re.compile(r"(var\s+sysUserType\s*=\s*')[^']*(')", re.IGNORECASE), rf"\g<1>{config.TARGET_USER_TYPE}\2"),
    (re.compile(r"(var\s+sptUserType\s*=\s*')[^']*(')", re.IGNORECASE), rf"\g<1>{config.TARGET_USER_TYPE}\2"),
    (re.compile(r"(var\s+Userlevel\s*=\s*)\d+", re.IGNORECASE), rf"\g<1>{config.ADMIN_USER_LEVEL}"),
    (re.compile(r"(var\s+UserLeveladmin\s*=\s*')[^']*(')", re.IGNORECASE), rf"\g<1>{config.TARGET_USER_TYPE}\2"),
]

FEATURE_OVERRIDE_PATTERNS = [
    (re.compile(r"(var\s+IsSmartDev\s*=\s*[\"'])[^\"']*([\"'])"), r"\g<1>1\2"),
]

HIDDEN_ELEMENT_PATTERNS = [
    (re.compile(r'(display\s*:\s*)none(\s*;?\s*["\'])'), r"\g<1>block\2"),
    (re.compile(r'(visibility\s*:\s*)hidden(\s*;?\s*["\'])'), r"\g<1>visible\2"),
]


def modify_user_type_response(body):
    for pattern, replacement in USER_TYPE_PATTERNS:
        body = pattern.sub(replacement, body)
    return body


def modify_get_cur_user_type(body):
    stripped = body.strip()
    if stripped in ("1", "2"):
        return config.TARGET_USER_TYPE
    return body


def modify_feature_flags(body):
    for pattern, replacement in FEATURE_OVERRIDE_PATTERNS:
        body = pattern.sub(replacement, body)
    return body


def modify_hidden_elements(body):
    for pattern, replacement in HIDDEN_ELEMENT_PATTERNS:
        body = pattern.sub(replacement, body)
    return body


def inject_menu_override_script(body):
    script = """
<script type="text/javascript">
(function() {
    var _origGetUserType = window.HW_WEB_GetUserType;
    if (typeof _origGetUserType === 'function') {
        window.HW_WEB_GetUserType = function() { return '""" + config.TARGET_USER_TYPE + """'; };
    }

    if (typeof curUserType !== 'undefined') { curUserType = '""" + config.TARGET_USER_TYPE + """'; }
    if (typeof sysUserType !== 'undefined') { sysUserType = '""" + config.TARGET_USER_TYPE + """'; }
    if (typeof Userlevel !== 'undefined') { Userlevel = """ + str(config.ADMIN_USER_LEVEL) + """; }

    var _origXhr = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url) {
        this._ontProxyUrl = url;
        return _origXhr.apply(this, arguments);
    };
})();
</script>
"""
    body = body.replace("</head>", script + "</head>", 1)
    return body


def modify_check_user_info(body):
    stripped = body.strip()
    if stripped in ("1", "2", "3"):
        return config.TARGET_USER_TYPE
    return body


def should_modify_response(path, content_type):
    if not content_type:
        return False
    ct = content_type.lower()
    if "text/html" in ct or "text/asp" in ct or "application/javascript" in ct:
        return True
    if path and (".asp" in path.lower() or ".js" in path.lower() or ".cgi" in path.lower()):
        return True
    return False


def modify_response_body(path, body, content_type=""):
    if not body:
        return body

    path_lower = (path or "").lower()

    if "getcurusertype" in path_lower:
        return modify_get_cur_user_type(body)

    if "checkuserinfo" in path_lower or "checkuserresult" in path_lower:
        return modify_check_user_info(body)

    body = modify_user_type_response(body)
    body = modify_feature_flags(body)

    if "text/html" in (content_type or "").lower() or path_lower.endswith(".asp"):
        body = modify_hidden_elements(body)
        if "</head>" in body:
            body = inject_menu_override_script(body)

    return body


def modify_response_headers(headers):
    modified = {}
    for key, value in headers.items():
        k = key.lower()
        if k == "content-security-policy":
            continue
        if k == "x-frame-options":
            continue
        if k == "x-content-type-options":
            continue
        modified[key] = value
    return modified

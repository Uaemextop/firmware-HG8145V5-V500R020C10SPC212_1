var menuArray;

var IGMPEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_IPTV.IGMPEnable);%>';
var var_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
var var_singtel_hg8244hs = '<%HW_WEB_GetFeatureSupport(VOICE_FT_WEB_SINGTEL_HG8244HS);%>';
var var_usbstorage = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_USBSTORAGE);%>';

function IsSupportSamba() {
    var IsSupportSamba = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_USBPRINTER);%>';
    return parseInt(IsSupportSamba,10);
}

function IsSupportWifi() {
    var IsSupportWifi = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
    return parseInt(IsSupportWifi,10);
}

function IsWorkInAPBridged() {
    var APMode = '<%HW_WEB_GetAPChangeModeValue();%>'; 
    return (APMode == '2') || (APMode == '3');
}

function IsSupportVoice() {
    var IsSupportVoice = '<%HW_WEB_GetFeatureSupport(HW_VSPA_FEATURE_VOIP);%>';
    return parseInt(IsSupportVoice,10);
}

function setHtmlValue(id, value) {
    document.getElementById(id).innerHTML = value;
}

function RouterChangeSt(internet, internetnowifi, wifi, ont, usb, wifidev, linedev, teldev, wifima) {
    this.internet = internet;
    this.internetnowifi = internetnowifi;
    this.wifi = wifi;
    this.ont = ont;
    this.usb = usb;
    this.wifidev = wifidev;
    this.linedev = linedev;
    this.teldev = teldev;
    this.wifima = wifima;
}

var gstClickFlag = new RouterChangeSt(0,0,0,0,0,0,0,0,0);
function CondetailInfo(clicktType,flag, divid, pointerid, iframeid, frameurl,clickfuncstr) {
    this.clicktType = clicktType;
    this.flag = flag;
    this.divid = divid;
    this.pointerid = pointerid;
    this.iframeid = iframeid;
    this.frameurl = frameurl;
    this.clickfuncstr = clickfuncstr;
}

function SpecialDealFunc(flag) {
    var positionvalue = flag == "hide" ? "-10px" : "0px";
    $("#Contectdevlineinfo").css("top", positionvalue);
    return;
}

function ShowCenterFunc(flag, id) {
    if("hide" == flag) {
        return;
    }

    var newid="#"+id;
    $("#showcenter").attr("href", newid);
    document.getElementById("showcenter").click();
}

var gCondetailInfo = new Array( new CondetailInfo("internet",0,"internetstatusinfo",null,"InternetSrc", "../html/ssmp/smartontinfo/smatontinfo.asp"),
                                new CondetailInfo("internetnowifi",0,"nowifiinternetstatusinfo",null,"nowifiInternetSrc", "../html/ssmp/smartontinfo/smatontinfo.asp"),
                                new CondetailInfo("wifi",0,"ConfigWifiInfo",null, "ConfigWifiPageSrc", "../../html/amp/wlanbasic/simplewificfg.asp"),
                                new CondetailInfo("ont",0,"routermngt",null, "routermngtpageSrc", "../html/ssmp/accoutcfg/ontmngt.asp", SpecialDealFunc),
                                new CondetailInfo("usb",0,"usbsamba",null, "usbsambapageSrc", "../html/ssmp/samba/sambasmart.asp", SpecialDealFunc),
                                new CondetailInfo("wifidev",0,"Contectdevmngt","wifidevCntPointer", "ContectdevmngtPageSrc", "../html/bbsp/userdevinfo/userdevinfosmart.asp?type=wifidev"),
                                new CondetailInfo("linedev",0,"Contectdevmngt","linedevCntPointer", "ContectdevmngtPageSrc", "../html/bbsp/userdevinfo/userdevinfosmart.asp?type=linedev"),
                                new CondetailInfo("teldev",0,"Contectdevmngt","phonedevCntPointer", "ContectdevmngtPageSrc", "../../html/voip/status/smartvoipmaintain.asp"),
                                new CondetailInfo("wifima",0,"D2CodeDivInfo",null, null, null),
                                null);

function ChangeClickConfigDiv(ShowFlag, PageIdType, PointerId) {
    for(var index = 0; index < gCondetailInfo.length - 1; index++) {
        var OptPageId = gCondetailInfo[index].divid;
        var Optpointerid = gCondetailInfo[index].pointerid;
        var clicktType = gCondetailInfo[index].clicktType;
        var clickfuncstr = gCondetailInfo[index].clickfuncstr;
        gstClickFlag[clicktType] = false;
        if(undefined !=  clickfuncstr) {
            clickfuncstr("hide");
        }
    }

    for(var index = 0; index < gCondetailInfo.length - 1; index++) {
        if(PageIdType == gCondetailInfo[index].clicktType) {
            //ShowFlag为true则需要隐藏，ShowFlag为false则需要显示，
            var ShowType = ShowFlag == true ? "hide" : "block";
            var clicktTypestr = gCondetailInfo[index].clicktType
            var ClickPageId = gCondetailInfo[index].divid;
            var Clickpointerid = gCondetailInfo[index].pointerid;
            var clickfuncstr = gCondetailInfo[index].clickfuncstr;
            gstClickFlag[clicktTypestr] = !ShowFlag;
            if(undefined != gCondetailInfo[index].iframeid
               && undefined != gCondetailInfo[index].frameurl) {
                var iframeId = "iframe#" + gCondetailInfo[index].iframeid;
                if("block" == ShowType){
                    $(iframeId).attr("src", gCondetailInfo[index].frameurl);
                } else {
                    $(iframeId).attr("src", "");
                }
            }

            if(undefined != clickfuncstr) {
                clickfuncstr(ShowType);
            }

            if("Contectdevmngt" == ClickPageId) {
                ShowCenterFunc(ShowType, ClickPageId);
            }
            break;
        }
    }
}

var FrameMainPage = {
    init : function() {
        this.initData();
        this.initElement();
        this.menuItems = eval(menuArray);
    },

    initData : function() {
        var frame = this;
    },

    initElement : function() {
        this.InitMainpageDesInfo();
        this.InitONTInfo();
        this.InitUSBInfo();
    },

    InitMainpageDesInfo:function() {
        var frame = this;
        if(true == IsSupportWifi() && true == IsSupportVoice()) {
            if (false ==IsWorkInAPBridged()) {
                this.initInitStatus();
            } else {
                this.initInitStatusNowifi();
            }

            this.InitWIFIDevInfo();
            this.InitLineDevInfo();
            this.InitPhoneDevInfo();

            $("#WIFIIconInfo").mouseover(function() {
                $("#WIFIIcon").css("background", "url( ../images/wifiseticonmove.jpg) no-repeat center");
             });

            $("#WIFIIconInfo").mouseout(function() {
                $("#WIFIIcon").css("background", "url( ../images/wifiseticon.jpg) no-repeat center");
            });

           $("#WIFIIconInfo").click(function() {
                frame.clickconfigwifi();
            });
            return;
        } else if(true == IsSupportWifi() && false == IsSupportVoice()) {
            if (false ==IsWorkInAPBridged()) {
                this.initInitStatus();
            } else {
                this.initInitStatusNowifi();
            }

            this.InitWIFIDevInfo();
            this.InitLineDevInfowithoutvoip();

            $("#WIFIIconInfo").mouseover(function() {
                $("#WIFIIcon").css("background", "url( ../images/wifiseticonmove.jpg) no-repeat center");
             });

            $("#WIFIIconInfo").mouseout(function() {
                $("#WIFIIcon").css("background", "url( ../images/wifiseticon.jpg) no-repeat center");
            });

           $("#WIFIIconInfo").click(function() {
                frame.clickconfigwifi();
            });
        } else if(false == IsSupportWifi() && true == IsSupportVoice()) {
            this.initInitStatusNowifi();
            frame.InitLineDevCntInfoWithoutWIFI();
            this.InitPhoneDevInfo();
            return;
        } else if(false == IsSupportWifi() && false == IsSupportVoice()) {
            this.initInitStatusNowifi();
            
            if (IsSupportBridgeWan == 0) {
                $("#linedevline").css("margin-left", "350px");
                $("#linedevCnt").css("margin-left", "335px");
                $("#linedevCntSpan").css("margin-left", "30px");
                this.InitLineDevInfo();
            }
        }
    },

    initInitStatus: function() {
        var frame = this;
        $("#InternetIcon").mouseover(function() {
            $("#InternetIcon").css("background", "url( ../images/interneticonmove.jpg) no-repeat center");
        });

        $("#InternetIcon").mouseout(function() {
            $("#InternetIcon").css("background", "url( ../images/interneticon.jpg) no-repeat center");
        });

       $("#InternetIcon").click(function() {
            frame.clickInternet();
        });
    },

    initInitStatusNowifi:function() {
        var frame = this;
        $("#NowifiInternetIcon").mouseover(function() {
            $("#NowifiInternetIcon").css("background", "url( ../images/interneticonmove.jpg) no-repeat center");
        });

        $("#NowifiInternetIcon").mouseout(function() {
            $("#NowifiInternetIcon").css("background", "url( ../images/interneticon.jpg) no-repeat center");
        });

       $("#NowifiInternetIcon").click(function() {
            frame.clickInternetnowifi();
        });
    },

    clickInternet:function() {
        InternetWanDiagnose();
        ChangeClickConfigDiv(gstClickFlag.internet,"internet",null);
    },

    clickInternetnowifi:function() {
        InternetWanDiagnose();
        ChangeClickConfigDiv(gstClickFlag.internetnowifi,"internetnowifi",null);
    },

    InitLineDevCntInfoWithoutWIFI:function() {
        var frame = this;
        $("#wifidevline").css("background", "url( ../images/CntLeftLine.jpg) no-repeat center");
        $("#wifidevIcon").css("background", "url( ../images/linedev.jpg) no-repeat center");

        $("#wifidevCnt").mouseover(function() {
            $("#wifidevIcon").css("background", "url( ../images/linedevmove.jpg) no-repeat center");
        });

        $("#wifidevCnt").mouseout(function() {
            $("#wifidevIcon").css("background", "url( ../images/linedev.jpg) no-repeat center");
        });

        var wifiIndex = 0;
        var LineIndex = 0;
        for(var index = 0; index < gCondetailInfo.length - 1; index++) {
            if("wifidev" == gCondetailInfo[index].clicktType) {
                wifiIndex = index;
            }

            if("linedev" == gCondetailInfo[index].clicktType) {
                LineIndex = index;
            }
        }

        gCondetailInfo[wifiIndex].frameurl = gCondetailInfo[LineIndex].frameurl;

         $("#wifidevCnt").click(function() {
            frame.ClickWifiDevInfo();
        });
    },

    InitLineDevInfowithoutvoip:function() {
        var frame = this;
        $("#phonedevIcon").css("background", "url( ../images/linedev.jpg) no-repeat center");
        
        $("#phonedevCnt").mouseover(function() {
            $("#phonedevIcon").css("background", "url( ../images/linedevmove.jpg) no-repeat center");
        });

        $("#phonedevCnt").mouseout(function() {
            $("#phonedevIcon").css("background", "url( ../images/linedev.jpg) no-repeat center");
        });

        var TelIndex = 0;
        var LineIndex = 0;
        for(var index = 0; index < gCondetailInfo.length - 1; index++) {
            if("teldev" == gCondetailInfo[index].clicktType) {
                TelIndex = index;
            }

            if("linedev" == gCondetailInfo[index].clicktType) {
                LineIndex = index;
            }
        }

        gCondetailInfo[TelIndex].frameurl = gCondetailInfo[LineIndex].frameurl;

         $("#phonedevCnt").click(function() {
            frame.ClickPhoneDevInfo();
        });
    },

    clickconfigwifi:function() {
        if(1 == gstClickFlag.wifi) {
            $("#WIFIIcon").css("background", "url( ../images/wifiseticon.jpg) no-repeat center");

        } else {
            $("#WIFIIcon").css("background", "url( ../images/wifiseticonmove.jpg) no-repeat center");
        }
        ChangeClickConfigDiv(gstClickFlag.wifi,"wifi",null);
    },

    clickShowwifima:function(){
        ChangeClickConfigDiv(gstClickFlag.wifima,"wifima",null);
    },

    InitONTInfo: function() {
        var frame = this;
        $("#routerclick").mouseover(function() {
            $("#routericon").css("background", "url( ../images/routerpress.jpg) no-repeat center");
        });

        $("#routerclick").mouseout(function() {
            $("#routericon").css("background", "url( ../images/router.jpg) no-repeat center");
        });

       $("#routerclick").click(function() {
            frame.ClickONTInfo();
        });

       $("#RestartDiv").mouseover(function() {
            $("#RestartIcon").css("background", "url( ../images/reseticonpress.jpg) no-repeat center");
        });

        $("#RestartDiv").mouseout(function() {
            $("#RestartIcon").css("background", "url( ../images/reseticon.jpg) no-repeat center");
        });

       $("#RestartDiv").click(function() {
            frame.ClickONTInfo();
        });
    },

    ClickONTInfo:function() {
        if(1 == gstClickFlag.ont) {
            $("#routericon").css("background", "url( ../images/router.jpg) no-repeat center");

        } else {
            $("#routericon").css("background", "url( ../images/routerpress.jpg) no-repeat center");
        }
        ChangeClickConfigDiv(gstClickFlag.ont,"ont",null);
    },

    InitUSBInfo:function() {
        var frame = this;
         $("#usbport").mouseover(function() {
            $("#usbportIcon").css("background", "url( ../images/usbiconpress.jpg) no-repeat center");
        });

        $("#usbport").mouseout(function() {
            $("#usbportIcon").css("background", "url( ../images/usbicon.jpg) no-repeat center");
        });

        $("#usbport").click(function() {
            if (var_usbstorage == "0") {
                return;
            }
            frame.ClickUsbInfo();   
        });
    },

    ClickUsbInfo:function() {
        ChangeClickConfigDiv(gstClickFlag.usb,"usb",null);
    },

    InitWIFIDevInfo:function() {
        var frame = this;
        $("#wifidevCnt").mouseover(function() {
            $("#wifidevIcon").css("background", "url( ../images/wifiiconmove.jpg) no-repeat center");
        });

        $("#wifidevCnt").mouseout(function() {
            $("#wifidevIcon").css("background", "url( ../images/wifiicon.jpg) no-repeat center");
        });

        $("#wifidevCnt").click(function() {
            frame.ClickWifiDevInfo();
        });
    },

    ClickWifiDevInfo:function() {
        SetDeviceNum();
        ChangeClickConfigDiv(gstClickFlag.wifidev,"wifidev",null);
    },

    InitLineDevInfo:function() {
        var frame = this;
        $("#linedevCnt").mouseover(function() {
            $("#linedevIcon").css("background", "url( ../images/linedevmove.jpg) no-repeat center");
        });

        $("#linedevCnt").mouseout(function() {
            $("#linedevIcon").css("background", "url( ../images/linedev.jpg) no-repeat center");
        });

        $("#linedevCnt").click(function() {
            frame.ClickLineDevInfo();
        });
    },

    ClickLineDevInfo:function() {
        SetDeviceNum();
        ChangeClickConfigDiv(gstClickFlag.linedev,"linedev",null);
    },

    InitPhoneDevInfo:function() {
        var frame = this;
        $("#phonedevCnt").mouseover(function() {
            $("#phonedevIcon").css("background", "url( ../images/phoneiconmove.jpg) no-repeat center");
        });

        $("#phonedevCnt").mouseout(function() {
            $("#phonedevIcon").css("background", "url( ../images/phoneicon.jpg) no-repeat center");
        });

        $("#phonedevCnt").click(function() {
            frame.ClickPhoneDevInfo();
        });
    },

    ClickPhoneDevInfo:function() {
        SetDeviceNum();
        ChangeClickConfigDiv(gstClickFlag.teldev,"teldev",null);
    },

    showmainpage : function() {
        var frame = this;
        $(document).ready(function() {
            frame.init();
        });
    }
};

FrameMainPage.showmainpage();

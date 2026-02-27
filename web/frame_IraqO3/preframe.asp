
var ssidIdx = 0;
var changeWlanClick = 1;
var WlanBasicPage = '2G';
var WlanAdvancePage = '2G';
var lanDevIndex = 1;
var QoSCurInterface = '';
var DDNSProvider = '';
var ripIndex = "";
var previousPage = "";
var preAddDomain = "";
var editIndex = -1;
var editDomain = '';
var sptUserType = '1';
var sysUserType = '0';
var MenuName = "";
var StartIndex = 1;
var Menu2Path = "";
var authMode = 0;
var Passwordmode = 0;
var changeMethod = 999;
var UpgradeFlag = 0;
var SaveDataFlag = 0;
var collectType = "";
var PwdModifyFlag = 1;
var PwdAspNum = 0;
var SystemToolsNum = 0;
var posDeviceInfo = 0;
var EquipFlag = 0;
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var posRecharge = 0;

var CfgMode ='<%HW_WEB_GetCfgMode();%>';
//var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
//var curWebMenuPath = '<%HW_WEB_GetWEBMenuPath();%>';
//var pageName11 = '<%webGetReplacePage();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var jumptomodifypwd = '<%HW_WEB_GetWebUserMdFlag();%>';
var menuArray = <%HW_WEB_GetWebMenuArray();%>;
var TitleName = "Go Fiber";
document.title = TitleName;

var Frame = {
	menuItems : [],
	mainMenuCounter : 0,
	subMenuCounter : 0,
	$mainMenu : null,
	$subMenu : null,
	$content : null,

	init : function() {
		this.initData();
		this.initElement();
	},

	initData : function() {
		var frame = this;

		this.mainMenuCounter = 0;
		this.subMenuCounter = 0;

		this.$mainMenu = $("#nav");
		this.$subMenu = $("#headerTab ul");
		this.$content = $("#frameContent");

		this.$content.on("load", function() {
			frame.$content.show();
			frame.setContentHeight();
		});

		this.menuItems = eval(menuArray);
	},
	
	initElement : function() {
		$("#headerTitle").text(TitleName);

		this.setLogoutElement();
		this.setCallUs();
		this.setNavSpan();
		this.setCopyRightInfo();
		this.setFootLink();		

		if (this.menuItems.length > 0) 
		{			
			MenuName = this.menuItems[0].name;
			Menu2Path = this.menuItems[0].subMenus[0].name;
			this.addMenuItems(this.$mainMenu, this.menuItems, "main");
			this.addMenuItems(this.$subMenu, this.menuItems[0].subMenus, "sub");
		}
	},

	addMenuItems : function(element, menus, type) {
		var frame = this;
		element.empty();
		if(type == "main") {
			this.mainMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) 
			{
				if(menus[i].name == "Home" || menus[i].name == "Advanced")
				{
					element.append('<div class="menu_sec" value="' + i + '"><div class="leftspace">' + menus[i].name + '</div><div class="rightspace"></div></div>');
				}
			}

			element.children("div").eq(0).addClass("hover");

			element.children("div").click(function() 
			{
				var hoverIndex=($(this).attr("value"));
				if("Advanced" == menus[hoverIndex].name)
				{
					window.location.replace("/index.asp");
					return;
				}
				
				element.children("div").eq(frame.mainMenuCounter).removeClass("hover");
				element.children("div").eq(hoverIndex).addClass("hover");
				frame.mainMenuCounter = hoverIndex;
				MenuName = menus[hoverIndex].name;
				frame.addMenuItems($("#headerTab ul"), menus[hoverIndex].subMenus, "sub");
			});
		}
		else if (type == "sub") 
		{
			this.subMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) 
			{
				element.append('<li value="' + i + '">' +
					'<div class="tabBtnLeft"></div>' +
					'<div class="tabBtnCenter">' + menus[i].name + '</div>' +
					'<div class="tabBtnRight"></div>' +
				'</li>');
				
				if("Recharge" == menus[i].name)
				{
					posRecharge = i;
				}
			}
			
			element.children("li").eq(frame.subMenuCounter).removeClass("hover");
			element.children("li").eq(posRecharge).addClass("hover");
			frame.subMenuCounter = posRecharge;
			Menu2Path = menus[posRecharge].name;
			frame.setContentPath(menus[posRecharge].url);

			element.children("li").click(function(){
				element.children("li").eq(frame.subMenuCounter).removeClass("hover");
				element.children("li").eq(this.value).addClass("hover");
				frame.subMenuCounter = this.value;

				Menu2Path = menus[this.value].name;
				frame.setContentPath(menus[this.value].url);
			});
		}
	},

	setContentPath : function(url) {
		this.$content.attr("src", url);
	},

	setContentHeight : function() {
		setInterval(function() {
			try {
				var height = 0;

				if (window.ActiveXObject) {
					height = document.getElementById("frameContent").contentWindow.document.body.scrollHeight;
				}
				else if (window.XMLHttpRequest) {
					height = document.getElementById("frameContent").contentWindow.document.body.offsetHeight;
				}
				height = Math.max(height, 570, this.$("#nav").length * 25);
				$("#center").height(height + 25);
				$("#nav").height(height + 25);
				$("#content").height(height + 25);
				$("#frameWarpContent").height(height);
				$("#frameContent").height(height);
			} catch (e) {

			}
		}, 200);
	},

	setLogoutElement : function() 
	{
		$("#headerLogout span").html("Logout");
		
		var frame = this;

		$("#headerLogout span").mouseover(function() {
		
			$("#headerLogout span").css({
				"color" : "#000000",
				"text-decoration" : "underline",
				"cursor": "pointer"
			});
			
		});
		$("#headerLogout span").mouseout(function() {
			$("#headerLogout span").css({
				"color" : "#000000",
				"text-decoration" : "none"
			});
		});
		$("#headerLogout span").click(function() {
			frame.clickLogout();
		});

		$("#headerLogoutImg").click(function() 
		{
			frame.clickLogout();
		});
	},
	
	setNavSpan : function() 
	{
		$("#topNav span").html("Welcome");
	},
	
	setCallUs : function() 
	{
		$("#CallUs span").html("Call us 066186");
	},

	setCopyRightInfo : function() 
	{
		$("#footerText").html("Copyright © O3.All rights reserved.");
	},
	
	setFootLink : function() 
	{
		$("#footLink span").html("O3 Telecom");
		
		$("#footLinkO3").click(function() 
		{
			window.open("http://www.o3-telecom.com", "_blank");
		});
		
		$("#footLinkFaceBook").click(function() 
		{
			window.open("https://www.facebook.com/O3-Telecom-170721689962978/", "_blank");
		});
		
		$("#footLinkYouTube").click(function() 
		{
			window.open("https://www.youtube.com/channel/UCxghM9XAkl0NrgzvdUtJhFw", "_blank");
		});
	},	

	clickLogout : function() {
		logoutfunc();
	},
	show : function() {
		var frame = this;
		$(document).ready(function() {
			frame.init();
		});
	},
	
	showjump : function(hpa,zpa)
	{
		if((productName == 'HG8045') && (curUserType == sysUserType))
		{
			hpa--;
		}
		this.$mainMenu.children("li").eq(this.mainMenuCounter).removeClass("hover");
		this.$mainMenu.children("li").eq(this.menuItems.length-hpa).addClass("hover");
		this.mainMenuCounter=this.menuItems.length-hpa;
		this.addMenuItems($("#nav ul"), this.menuItems[this.menuItems.length-hpa].subMenus, "sub");
		this.$subMenu.children("li").eq(this.subMenuCounter).removeClass("hover");
		this.$subMenu.children("li").eq(zpa).addClass("hover");
		MenuName = this.menuItems[this.menuItems.length-hpa].name;
		Menu2Path = this.menuItems[this.menuItems.length-hpa].subMenus[zpa].name;
		this.setContentPath(this.menuItems[this.menuItems.length-hpa].subMenus[zpa].url);
		this.subMenuCounter=zpa;
	}
};

Frame.show();


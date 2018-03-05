(function ($) {
    var fn = function () { }
    fn.prototype = {
        lat: '',//纬度
        lon: '',//经度
        RegistrationID: '',
        pictureBase64:'',
        init: function () {
            _self = this;
        },
        nativeGetGpsLocation: function () {
            cordova.exec(
                function (result) { this.lat = result["latitude"]; this.lon = result["longitude"]; return this.lon + "," + this.lat; },
                function () { return "error"},
                "CDVLocation",
                "getLocation",
                []);
        },
        nativeGetRegistrationID: function () {
            window.plugins.jPushPlugin.init();
            window.plugins.jPushPlugin.getRegistrationID(function (data) {
                //this.RegistrationID = data;
                var objectData = new Object();
                objectData.UserName = document.querySelector("#account").value;
                objectData.PassWord = document.querySelector("#password").value;
                objectData.channelidX = data;
                objectData.useridX = data;
                objectData.PhoneType = 1;
                $.ActionFn.sendData("RequestLogIn", objectData, successCallBac)
                function successCallBac(returnData) {
                    if (returnData.Rtn_Code == "0") {
                        $.ActionFn.SetlocalStorage("launchFlag", "1");
                        $.ActionFn.SetlocalStorage("launchData", objectData);
                        $.ActionFn.setPagesData(returnData.Content, "userInfo");
                        mui.openWindow({
                            url: 'Index.html',
                            id: 'index',
                            createNew: false,//是否重复创建同样id的webview，默认为false:不重复创建，直接显示
                        })
                    }
                    else if (returnData.Rtn_Code == "-1") {
                        mui.alert(returnData.Rtn_Msg, '警告', function () {
                        });
                    }
                }
               // return _self.RegistrationID;
            });
        },
        nativeGetPicture: function () {
            navigator.camera.getPicture(
                function (imageURL) {
                    this.pictureBase64 = imageURL
                    return (this.pictureBase64);
                },
                function () { return "error"},
                { quality: 20, destinationType: Camera.DestinationType.FIRL_URI, sourceType: Camera.PictureSourceType.CAMERA }
                );
        },
        returnLocation: function () {
            return this.nativeGetGpsLocation();
        },
        returnRegistrationID: function () {
            //return 1;
            alert(this.RegistrationID)
            return this.RegistrationID;
        },
        returnPictureBase: function () {
            return nativeGetPicture();
        }
    }
    $.fn = new fn();
})(jQuery)

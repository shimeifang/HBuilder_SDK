(function($) {
	var ActionFn = function() {};
	var returnData = "";
	ActionFn.prototype = {
		extras: "extras",
		/*
		 *发送数据
		 * 
		 */
		postData: function(xurl, SubmitData, CallBackSuccess, CallBackError, callBackFinish) {
			/*
			发送前增加网络判断
			*/
			$.ajax({
				type: 'post',
				url: xurl,
				data: SubmitData,
				contentType: "application/x-www-form-urlencoded",
				dataType: 'JSON',
				beforeSend: function(XMLHttpRequest) {},
				success: function(getData) {

					CallBackSuccess(getData);
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					if(typeof CallBackError == "undefined") {
						if(textStatus == "timeout") {} else if(textStatus == "error") {} else if(textStatus == "notmodified") {} else if(textStatus == "parsererror") {}
					} else {
						CallBackError();
					} //
				},
				complete: function() {
					if(typeof callBackFinish != "undefined") {
						callBackFinish();
					}
				}
			});
		},
		/*
		 * 得到json数据
		 */
		getJsonData: function(obj) {
			if(typeof obj != "object") {
				return "bad param";
			} else {
				return this.Serialize(obj);
				//console.log(encodeURIComponent (this.Serialize(obj)))
			}
		},
		/*
		 * 得到发送报文
		 */
		getInterData: function(RequestName, obj) {
			var _interData = new Object();
			_interData.RequestName = RequestName;
			//_interData.Partner = "ZSPMS";
			_interData.Signed = this.getSignStr_Md5();
			_interData.TimeStamp = this.getNowDate("timeStamp");
			// _interData.EncType = "1001";
			//_interData.Content = this.getSignStr_DES(_interData.TimeStamp, this.getJsonData(obj));
			_interData.Content = obj;
			console.log(this.getJsonData(_interData));
			return this.getJsonData(_interData);
		},
		/*
		 * 获得当前时间戳
		 * @param {String} 时间类型 "timeStamp" 为时间戳 "dateTime" 为 时间
		 * @return number||string
		 * @date 2016-6-29 
		 * @author sjh
		 */
		getNowDate: function(n) {
			var _timeStamp = "";
			if(n == "timeStamp") {
				_timeStamp = (new Date()).getTime();
			} else if(n == "dateTime") {
				_timeStamp = this.timeFormat((new Date()), "yyyy-MM-dd hh:mm:ss")
			}
			return _timeStamp
		},
		/*
		 *获得md5加密数据
		 * @return string
		 * @date 2016-6-30
		 * @author sjh
		 */
		getSignStr_Md5: function() {
			return hex_md5(this.getNowDate("timeStamp") + "bubu100");
		},
		/*
		 *获得DES加密数据
		 * @param {String} _TimeStamp 时间戳
		 * @param {String} _dateContent 数据内容
		 * @return string
		 * @date 2016-6-30
		 * @author sjh
		 */
		getSignStr_DES: function(_TimeStamp, _dateContent) {
			//console.log(_dateContent);
			//console.log(_TimeStamp);
			//console.log(this.stringToHex(des(_TimeStamp.toString(), _dateContent, 1, 0)));
			//return encodeURIComponent(this.stringToHex(des(_TimeStamp+"bubu100", _dateContent, 1, 0)));
			//return this.stringToHex(des(_TimeStamp + "bubu100", _dateContent, 1, 0));
		},

		/*
		 * 时间序列器
		 */
		timeFormat: function(_date, fmt) {
			var o = {
				"M+": _date.getMonth() + 1, //月份   
				"d+": _date.getDate(), //日   
				"h+": _date.getHours(), //小时   
				"m+": _date.getMinutes(), //分   
				"s+": _date.getSeconds(), //秒   
				"q+": Math.floor((_date.getMonth() + 3) / 3), //季度   
				"S": _date.getMilliseconds() //毫秒   
			};
			if(/(y+)/.test(fmt))
				fmt = fmt.replace(RegExp.$1, (_date.getFullYear() + "").substr(4 - RegExp.$1.length));
			for(var k in o)
				if(new RegExp("(" + k + ")").test(fmt))
					fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
			return fmt;
		},

		/*
		 * string 转换为hex
		 * @param {String} s 需要转换的值
		 * @return string
		 * @date 2016-6-30
		 * @author sjh
		 */
		stringToHex: function(s) {
			var r = "";
			var hexes = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f");
			for(var i = 0; i < (s.length); i++) {
				r += hexes[s.charCodeAt(i) >> 4] + hexes[s.charCodeAt(i) & 0xf];
			}
			return r;
		},

		/*
		 * 发送数据
		 */
		sendData: function(RequestName, obj, CallBackSuccess, CallBackError, callBackFinish) {
			//测试版
			return this.postData("http://112.124.36.112:8023/Receive.aspx", this.getInterData(RequestName, obj), CallBackSuccess, CallBackError, callBackFinish);
			//正式版
			//return this.postData("http://112.124.36.112:9090/Receive.aspx", this.getInterData(RequestName, obj), CallBackSuccess, CallBackError);
		},

		/*
		 *序列化工具
		 */
		Serialize: function(obj) {
			if(typeof obj == "undefined") {
				return "\"\"";
			}
			switch(obj.constructor) {
				case Object:
					var str = "{";
					for(var o in obj) {
						str += "\"" + o + "\"" + ":" + this.Serialize(obj[o]) + ",";
					}
					if(str.substr(str.length - 1) == ",")
						str = str.substr(0, str.length - 1);
					return str + "}";
					break;
				case Array:
					var str = "[";
					for(var o in obj) {
						str += this.Serialize(obj[o]) + ",";
					}
					if(str.substr(str.length - 1) == ",")
						str = str.substr(0, str.length - 1);
					return str + "]";
					break;
				case Boolean:
					return "\"" + obj.toString() + "\"";
					break;
				case Date:
					return "\"" + obj.toString() + "\"";
					break;
				case Function:
					break;
				case Number:
					return "\"" + obj.toString() + "\"";
					break;
				case String:
					return "\"" + obj.toString() + "\"";
					break;
				default:
					break;
			}

		},
		/*
		 * 本地存储--设置
		 * @param {String} key 存入键值对--键
		 * @param {String} value 存入键值对--值
		 * @returns void
		 * @date 2016-6-29 17:17:32
		 * @author sjh
		 */
		SetlocalStorage: function(key, value) {
			var Setdata = JSON.stringify(value)
			window.localStorage.setItem(key, Setdata);
		},
		/*
		 * 本地存储--获取
		 * @param {String} key 获取本地存储的键
		 * @returns void
		 * @date 2016-6-29 17:17:32
		 * @author sjh
		 */
		GetlocalStorage: function(key) {
			var Getdata = window.localStorage.getItem(key);
			if(Getdata != "undefined") {
				return JSON.parse(Getdata);
			} else {
				return null;
			}

		},
		/*
		 * 本地存储--移除
		 * @param {String} key 移除本地存储的键
		 * @returns void
		 * @date 2016-6-29 17:17:32
		 * @author sjh
		 */
		RemovelocalStorage: function(key) {
			window.localStorage.removeItem(key);
		},
		/*
		 * 本地会话--设置
		 * @param {String} value 存入键值对--值
		 * @param {String} key 存入键值对--键（可为空）
		 * @returns void
		 * @date 2016-7-27 13:36:11
		 * @author sjh
		 */
		setPagesData: function(value, key) {
			var setData = JSON.stringify(value)
			if(typeof key == undefined) {
				window.sessionStorage.setItem(this.extras, setData);
			} else {
				window.sessionStorage.setItem(key, setData);
			}
		},
		/*
		 * 本地会话--获取
		 * @param {String} key 获取本地存储的键（可为空）
		 * @returns void
		 * @date 2016-7-27 13:39:18
		 * @author sjh
		 */
		getPagesData: function(key) {
			if(typeof key == undefined) {
				var getData = window.sessionStorage.getItem(this.extras);
			} else {
				var getData = window.sessionStorage.getItem(key);
			}
			return JSON.parse(getData)
		},
		/*
		 * 本地会话--移除
		 * @param {String} key 移除本地存储的键（可为空）
		 * @returns void
		 * @date 2016-7-27 13:39:13
		 * @author sjh
		 */
		removePagesData: function(key) {
			if(typeof key == undefined) {
				window.sessionStorage.removeItem(this.extras);
			} else {
				window.sessionStorage.removeItem(key);
			}
		},
		selfOpenWindow: function(_id, _url, _extdata) {
			mui.openWindow({
				id: _id,
				url: _url,
				createNew: false,
				waiting: {
					autoShow: true, //自动显示等待框，默认为true
					title: '正在加载...', //等待对话框上显示的提示内容
				},
				extras:{},
				show: {
					autoShow: true, //页面loaded事件发生后自动显示，默认为true
					aniShow: "slide-in-right", //页面显示动画，默认为”“；
					duration: 200 //页面动画持续时间，Android平台默认100毫秒，iOS平台默认200毫秒；
				}
			})
		},
		selfFireFunction: function(_id, _actid, _val) {
			var detailPage = null
			if(!detailPage) {
				detailPage = plus.webview.getWebviewById(_id);
			}
			//触发详情页面的newsId事件
			mui.fire(detailPage, _actid, {
				extdata: _val || ""
			})
		}
	}
	$.ActionFn = new ActionFn;
})(jQuery)
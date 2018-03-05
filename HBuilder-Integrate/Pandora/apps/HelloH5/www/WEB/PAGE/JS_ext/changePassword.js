(function (mui, doc) {
    				mui.init();
					var regButton = doc.getElementById('reg');
					var accountBox = doc.getElementById('account');
					var passwordBox = doc.getElementById('password');  
					var passwordConfirmBox = doc.getElementById('password_confirm');
					var launchData = $.ActionFn.GetlocalStorage("launchData");
					regButton.addEventListener('tap', function(event) {
						var regInfo = {
							account: accountBox.value,
							password: passwordBox.value,
							passwordConfirm: passwordConfirmBox.value
						};
						if(regInfo.account==""){
						    mui.toast('原密码不能为空');
						    document.getElementById("password").value = "";
						    document.getElementById("password_confirm").value = "";
							return;
						}
						else if (regInfo.account != launchData.PassWord) {
						    mui.toast('原密码不正确');
						    return;
						}
						else if (regInfo.password == "" )
						{
						    mui.toast('新密码不能为空');
						    return;
						}
					    else if (regInfo.passwordConfirm != regInfo.password) {
							mui.toast('新密码两次输入不一致');
							return;
					    }
						var userInfo= $.ActionFn.GetlocalStorage("userInfo");
						var objectData = new Object();
						objectData.ID = userInfo.RtnLoginList[0].ID;
						objectData.NewPswd = regInfo.password;
						$.ActionFn.sendData("UpdatePswd", objectData, successCallBac);
						function successCallBac(returndata)
						{
						    if (returndata.Rtn_Code == "0") {
						        mui.toast("修改密码成功！");
						    }
						}
					});

}(mui, document));
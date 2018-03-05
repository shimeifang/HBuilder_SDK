document.addEventListener( "plusready",  function()
{
    var _BARCODE = 'BDPush',
		B = window.plus.bridge;
    var BDPush =
    {
    	PluginTestFunction : function (successCallback, errorCallback )
		{
			var success = typeof successCallback !== 'function' ? null : function(args) 
			{
				successCallback(args);
			},
			fail = typeof errorCallback !== 'function' ? null : function(code) 
			{
				errorCallback(code);
			};
			callbackID = B.callbackId(success, fail);

			return B.exec(_BARCODE, "PluginTestFunction", [callbackID]);
		}
   };
    window.plus.BDPush = BDPush;
}, true );
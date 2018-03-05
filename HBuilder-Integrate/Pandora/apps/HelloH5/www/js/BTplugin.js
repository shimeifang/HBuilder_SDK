document.addEventListener( "plusready",  function()
      {
        var _BARCODE = 'BTPlugin',
        B = window.plus.bridge;
        var BTPlugin =
        {
        PluginTestFunction : function (args,successCallback, errorCallback)
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

        return B.exec(_BARCODE, "BTPrinterFunction", [callbackID,args]);
        }
        };
        window.plus.BTPlugin = BTPlugin;
  }, true );

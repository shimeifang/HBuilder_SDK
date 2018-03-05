document.addEventListener( "plusready",  function()
      {
        var _BARCODE = 'LocationTrackerPlugin',
        B = window.plus.bridge;
        var LocationTrackerPlugin =
        {
        LocationTrackerFunction : function (args,successCallback, errorCallback)
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

        return B.exec(_BARCODE, "LocationTrackerPlugin", [callbackID,args]);
        }
        };
        window.plus.LocationTrackerPlugin = LocationTrackerPlugin;
  }, true );

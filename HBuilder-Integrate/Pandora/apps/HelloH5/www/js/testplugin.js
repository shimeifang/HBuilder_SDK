document.addEventListener( "plusready",  function()
      {
                          var _BARCODE = 'Location',
                          B = window.plus.bridge;
                          var Location =
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
                        
                          return B.exec(_BARCODE, "LocationFuction", [callbackID]);
                          }
        };
        window.plus.Location = Location;
  }, true );

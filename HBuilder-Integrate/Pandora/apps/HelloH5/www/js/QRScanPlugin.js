document.addEventListener( "plusready",  function()
      {
        var _BARCODE = 'QRScan',
        B = window.plus.bridge;
        var QRScan =
        {
        callScanPlugin : function (args,successCallback, errorCallback)
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

        return B.exec(_BARCODE, "callScanPlugin", [callbackID,args]);
        }
        };
        window.plus.QRScan = QRScan;
  }, true );

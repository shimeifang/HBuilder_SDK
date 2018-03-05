document.addEventListener( "plusready",  function()
{
    var _BARCODE = 'pluginConnection',
		B = window.plus.bridge;
    var pluginConnection = 
    {
        PluginTestFunctionSync : function ()
        {                                	
            return B.execSync(_BARCODE, "PluginConnectionFunction", []);
        }
                          
    };
    window.plus.pluginConnection = pluginConnection;
}, true );
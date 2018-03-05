document.addEventListener( "plusready",  function()
{
    var _BARCODE = 'VoiceSpeak',
		B = window.plus.bridge;
    var VoiceSpeak =
    {
    	PluginVoiceSpeak : function (Argus, successCallback, errorCallback )
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

			return B.exec(_BARCODE, "voiceSpeakFuction", [callbackID, Argus]);
		},
        PluginAudioPlay : function (Argus, successCallback, errorCallback )
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

        return B.exec(_BARCODE, "avAudioPlayFuction", [callbackID, Argus]);
        }

    };
    window.plus.VoiceSpeak = VoiceSpeak;
}, true );
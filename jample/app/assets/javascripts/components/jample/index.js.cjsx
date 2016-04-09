Jample = React.createClass

  getInitialState: ->
    currentPatch: 0

  componentDidMount: ->
    midi = undefined
    data = undefined
    # request MIDI access
    # midi functions

    onMIDISuccess = (midiAccess) ->
      # when we get a succesful response, run this code
      midi = midiAccess
      # this is our raw MIDI data, inputs, outputs, and sysex status
      inputs = midi.inputs.values()
      # loop over all available inputs and listen for any MIDI input
      input = inputs.next()
      while input and !input.done
        # each time there is a midi message call the onMIDIMessage function
        input.value.onmidimessage = onMIDIMessage
        input = inputs.next()
      return

    onMIDIFailure = (error) ->
      # when we get a failed response, run this code
      console.log 'No access to MIDI devices or your browser doesn\'t support WebMIDI API. Please use WebMIDIAPIShim ' + error
      return

    onMIDIMessage = (message) =>
      data = message.data
      # this gives us our [command/channel, note, velocity] data.
      if  data[0] == 144  
        console.log 'MIDI data', data
        @setState(currentPatch: (data[1] - 36))
      # MIDI data [144, 63, 73]
      return

    if navigator.requestMIDIAccess
      navigator.requestMIDIAccess(sysex: false).then onMIDISuccess, onMIDIFailure
    else
      alert 'No MIDI support in your browser.'

    # ---
    # generated by js2coffee 2.2.0
  render: ->
    currentPatch = @props.patch_set.patches[@state.currentPatch]
    currentTrack = @props.track_set[@state.currentPatch]
    currentmp3 = @props.mp3_set[@state.currentPatch]
    <div className="row">
      {@grid()}
      <div className="col-md-6">  
        <p>
          {currentPatch.patch_index}
        </p>
        <p>
          {currentTrack.track_name_pretty}
        </p>
        <p>
          track_id: {currentTrack._id}
        </p>
        <p>
          mp3: {currentmp3}
        </p>
        <p>
          <button type="button" className="btn btn-danger" onClick={@init_16_patches}>Random Patches</button>
        </p>
      </div>  
      
    </div>

  init_16_patches: ->
    console.log("init_16_patches")
    $.ajax
      url: 'init_16_patches/'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) ->
        console.log(data)



    # field :patch_index, type: Integer
    # field :track_id, type: String
    # field :patch_set_id, type: String
    # field :start_onset_index, type: Integer
    # field :stop_onset_index, type: Integer
    # field :voiced_count, type: Integer
    # field :volume, type: Float
    # field :frozen, type: String, default: false


  grid: ->
    reversed_patches = @props.patch_set.patches
    <div className="col-md-6">  
      <table className="table">
        <tr>
          { reversed_patches.slice(12,16).map (patch) => <Patch key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
        <tr>
          { reversed_patches.slice(8,12).map (patch) => <Patch key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
        <tr>
          { reversed_patches.slice(4,8).map (patch) => <Patch key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
        <tr>
          { reversed_patches.slice(0,4).map (patch) => <Patch key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
      </table>
    </div>

window.Jample = Jample

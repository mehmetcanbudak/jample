Jample = React.createClass

  getInitialState: ->
    state = 
      currentPatch: 0
    for key,value of @props
      state[key] = value
    state
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
      if  (data[0] == 144) && (data[1] < 52) # the < 52 ignore the foot pedal
        console.log 'MIDI data', data
        previous_state = @state
        @setState(currentPatch: (data[1] - 36))
        @set_current_patch()
      # MIDI data [144, 63, 73]
      return

    if navigator.requestMIDIAccess
      navigator.requestMIDIAccess(sysex: false).then onMIDISuccess, onMIDIFailure
    else
      alert 'No MIDI support in your browser.'

    # ---
    # generated by js2coffee 2.2.0
  render: ->
    currentPatch = @state.patch_set.patches[@state.currentPatch]
    currentTrack = @state.track_set[@state.currentPatch]
    currentmp3 = @state.mp3_set[@state.currentPatch]
    <div className="wrapper">
      <div className="row">
        <div className="col-md-6">  
          <div className="form-group">  
            Filter
            <input type="text" id="filter_input" className="form-control" />
            <button type="button" className="btn btn-info" onClick={@set_filter}>Go</button>

          </div>
        </div>
      </div>

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
            <button type="button" className="btn btn-info" onClick={@init_16_patches}>Random Patches</button>
            <button type="button" className="btn btn-info" onClick={@init_16_patches_as_sequence}>Random Sequence</button>
            <button type="button" className="btn btn-info" onClick={@expand_single_patch_to_sequence}>Patch to Sequence</button>
          </p>
          <p>
            <button type="button" className="btn btn-danger" onClick={@shuffle_unfrozen}>Shuffle Unfrozen</button>
          </p>

        </div>  
        
      </div>
    </div>

  set_current_patch: ->
    console.log("set_current_patch")
    $.ajax
      url: 'set_current_patch/' + @state.currentPatch
      method: "GET"

  set_filter: ->
    console.log("set_filter")
    $.ajax
      url: 'set_filter/'
      method: "POST"
      data:
        filter_text: $('#filter_input').val()
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

    

  expand_single_patch_to_sequence: ->
    console.log("expand_single_patch_to_sequence")
    $.ajax
      url: 'expand_single_patch_to_sequence'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) =>
        @setState(data)
        console.log(data)


  shuffle_unfrozen: ->
    console.log("shuffle_unfrozen")
    $.ajax
      url: 'shuffle_unfrozen'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) =>
        @setState(data)
        console.log(data)
    
  init_16_patches: ->
    console.log("init_16_patches")
    $.ajax
      url: 'init_16_patches/'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) =>
        @setState(data)
        console.log(data)




  freezePatchCallback: (e) ->
    console.log($(e.currentTarget).is(':checked'))
    console.log($(e.currentTarget).val())
    chosen_patch = $(e.currentTarget).val()
    frozen = $(e.currentTarget).is(':checked')
    $.ajax
      url: 'freeze_patch/'+chosen_patch+'/'+frozen+'/'
      method: "GET"
      success: (data) =>
        @setState(data)
        console.log(data)

  grid: ->
    reversed_patches = @state.patch_set.patches
    <div className="col-md-6">  
      <table className="table">
        <tr>
          { reversed_patches.slice(12,16).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
        <tr>
          { reversed_patches.slice(8,12).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
        <tr>
          { reversed_patches.slice(4,8).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
        <tr>
          { reversed_patches.slice(0,4).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
        </tr>
      </table>
    </div>

window.Jample = Jample

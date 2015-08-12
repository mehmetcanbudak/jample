class PatchSet
	include Mongoid::Document
  include Mongoid::Timestamps::Created


	has_many :patches

  # add a class attr for current patchset
 
 	

  def self.init_16_patches
    new_patch_set = PatchSet.create({})

    (0..15).each do |index|
      patch = Patch.create({patch_index: index})
      patch.randomize_patch
      patch.patch_set = new_patch_set
      patch.save
    end
    CurrentPatch.set_current_patch_set(new_patch_set)
    new_patch_set.save

  end

  def self.init_16_patches_as_sequence
  	new_patch_set = PatchSet.create({})

    subset_search_string = CurrentPatch.last.subset_search_string
    subset_of_tracks = Track.where(path_and_file: /#{subset_search_string}/i, track_missing: false)
    track = subset_of_tracks.shuffle.first
    duration_in_slices = 12
    track_onset_array = track.onset_times

    usable_onset_times = track_onset_array.split(track_onset_array.size - (duration_in_slices+16)).first
    start_onset_index = track.onset_times.index( usable_onset_times.shuffle.first)

  	(0..15).each do |index|
  		patch = Patch.create({
        track: track,
        patch_index: index,
        start_onset_index: start_onset_index+index,
        stop_onset_index: start_onset_index+index+duration_in_slices
         })
  		patch.patch_set = new_patch_set
      patch.save
  		patch.cut_sample(index)
  	end
    CurrentPatch.set_current_patch_set(new_patch_set)
		new_patch_set.save

  end


  def p(patch_number)
    return self.patches[(patch_number - 1)]
  end


  def previous_patch_set
    mongoid = self.Created
    PatchSet.where(:conditions => {:_id.lt => mongoid}).sort({:_id=>-1}).limit(1).last

  end

  def next_patch_set
    mongoid = self.id
    PatchSet.where(:conditions => {:_id.gt => mongoid}).sort({:_id=>1}).limit(1).last
  end

end

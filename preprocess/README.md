# Preprocessing Pipeline

1. Save the Block and Trial information from the session's metadata file using the script `save_block_trial_info.m`
    - `trials.mat`
    - `blocks.mat`
2. Concatenate one EEG session's `.mat` files into a single variable using the script `append_files.m`
3. Change the Trigger channel (channel 130) using the script `change_trigger_channel.m`
    - Trigger 150, 250 -> Trial number
    - Colored Trials -> 0 (removed)
    - Trigger 100 -> 0
4. Import the data from MATLAB array to EEGLAB
5. Import Events from channel and delete that channel (channel 130)
6. Delete the Time channel (channe 1)
7. Import channel location file (`.xyz` file)
8. Bandpass Filter (1 Hz, 100 Hz)
9. Notch Filter to remove Iran's line noise (48 Hz, 52 Hz)
10. Downsample to 400 Hz (from 1200 Hz)
11. Visual Rejection
    - Define the trial boundaries on data using the script `before_visual_rejection_define_trials.m`
    - **Visually reject the data**
    - Identify the trials to be removed after visual rejection using the script `after_visual_rejection_rejected_trials.m`
    - Save the trial number of thoses trials that need to be removed in `rejected_trials_{subject#}.mat`


12. ICA (runica, 'extended' = 0)
13. Run the script`before_epoching_remove_rejected_trials.m`:
    - Remove the rejected trials specified in `rejected_trials_{subject#}.mat` from the data
    - Add 10'000 to the trigger of the 2nd image in a trial, so that they become distinguishable
14.  Extract epochs based on the 2nd img's events (Triggers > 10'000): (-0.2 sec, 0.6 sec)
15. Selected bad ICs (IC3, IC4) by looking at:
    - Components ERPs, Spectra maps, IC labeling
16. Re-referencing:
    - Add the reference channel's value to all channels using the script `rereferencing_part1.m`
    - rereference the data to their Average on EEGLAB
17. Baseline Correction (-200 ms, 0 ms)
18. Change the event markers so that it includes information about the Block type, Trial type, and Stimulus type using the script `trial_labeling.m`
    - Block Types: "Match", "nonMatch"
    - Trial Types: "Match", "nonMatch"
    - Stimulus Types: "Face", "House", "Inverse Face"
    - Example marker: "mmf" -> Match block, Match, trial, Face stimulus

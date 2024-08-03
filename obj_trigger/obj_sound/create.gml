event_inherited()

audio_name = "event:/sfx/pep/taunt"
loop = false
volume = 1

// -1: restart, 0: play, 1 pause, 2 stop
state = 0
paused = false

ap = undefined
execute = function() {
    self.set_color();

    // Audio creation
    if (is_undefined(ap)) { // Audio doesnt exist, create and play one
        ap = new_audioPlayer(audio_name)
    } else if (audio_name != ap.audioName) { // Audio exists, but the target changed, so destroy the old one and make a new one.
        audioPlayer_destroy(ap)
        ap = new_audioPlayer(audio_name)
    }


    if (state == -1) { // Restart
        audioPlayer_stop(ap)
        audioPlayer_play(ap, loop, volume)
    }
    if (state == 0) { // Play
        if (paused) { // Resume playing
            paused = false
            audioPlayer_pause(ap, false)
        } else if (!ap.audio_isPlaying) { // Audio was stopped, restart
            audioPlayer_play(ap, loop, volume)
        } else {
            audioPlayer_stop(ap)
            audioPlayer_play(ap, loop, volume)
        }
    }
    if (state == 1 and !paused) { // Pause
        paused = true
        audioPlayer_pause(ap, true)
    }
    if (state == 2) { // Stop
        audioPlayer_stop(ap)
    }

    // Trigger target trigger
    self.trigger_targets()
}
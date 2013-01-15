module KeyboardShortcuts

  KEYS = {
    :play => 'p',
    :quit => 'q',
    :forward => "$'\x1b\x5b\x43'",
    :backward => "$'\x1b\x5b\x44'"
  }

  def action(key)
    send_to_pipe KEYS.fetch(key.to_sym)
  end

end

=begin
z           Show Info
1           Increase Speed
2           Decrease Speed
j           Previous Audio stream
k           Next Audio stream
i           Previous Chapter
o           Next Chapter
n           Previous Subtitle stream
m           Next Subtitle stream
s           Toggle subtitles
q           Exit OMXPlayer
Space or p  Pause/Resume
-           Decrease Volume
+           Increase Volume
Left Arrow  Seek -30
Right Arrow Seek +30
Down Arrow  Seek -600
Up Arrow    Seek +600
=end

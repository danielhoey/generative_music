require 'forwardable'

module GenerativeMusic
class Phrase
  attr_reader :notes

  extend Forwardable
  def_delegators :@notes, :length 

  def initialize(options={})
    @notes = Array.new(options[:length]||0)
    @note_off_list = []
    @default_velocity = options[:velocity]
  end

  def insert_note(index, pitch, duration)
    @notes[index] = [pitch, duration]
    @notes[index+duration-1] = nil if @notes.length < index+duration # resize to include full phrase length
  end

  def play(midi, index)
    note_on = @notes[index]
    note_off = @note_off_list[index]

    if note_on
      pitch, duration = *note_on
      note_reference = midi.note(pitch, {velocity: @default_velocity})
      duration = @notes[index][1]
      @note_off_list[index+duration] = note_reference
    end

    if note_off
      midi.note_off(note_off)
    end
  end
end
end

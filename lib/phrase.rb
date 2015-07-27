require 'forwardable'

module GenerativeMusic
class Phrase
  attr_reader :notes

  extend Forwardable
  def_delegators :@notes, :length 

  def initialize(options={})
    @notes = Array.new(options[:length]||0) #TODO: should notes be a Hash?
    @note_off_list = []
    @options = options
  end

  def insert_note(index, pitch, duration, velocity=nil)
    @notes[index] = [pitch, duration]
    @notes[index] << velocity unless velocity.nil?
    @notes[index+duration-1] = nil if @notes.length < index+duration # resize to include full phrase length
  end

  def play(midi, index)
    note_on = @notes[index]
    note_off = @note_off_list[index]

    if note_on
      pitch, duration, velocity = *note_on
      options = @options
      options.merge!(velocity: velocity) unless velocity.nil?
      note_reference = midi.note(pitch, options)
      duration = @notes[index][1]
      @note_off_list[index+duration] = note_reference
    end

    if note_off
      midi.note_off(note_off)
    end
  end
end
end

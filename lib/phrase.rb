require 'forwardable'

module GenerativeMusic
class Phrase
  attr_reader :notes

  extend Forwardable
  def_delegators :@notes, :length 

  def initialize(options={})
    @notes = Array.new(options[:length]||0)
    @commands = []
    @default_velocity = options[:velocity]
  end

  def insert_note(index, pitch, duration)
    @notes[index] = [pitch, duration]
    @notes[index+duration-1] = nil if @notes.length < index+duration # resize to include full phrase length
  end

  def play(midi, index)
    c = commands[index]
    return if c.nil?

    if c[0] == :note
      note_reference = midi.note(*c[1..-1])
      duration = @notes[index][1]
      commands[index+duration] = [:note_off, note_reference]
    elsif c[0] == :note_off
      midi.note_off(*c[1..-1])
    end
  end

  def commands
    if @commands.empty?
      @commands = @notes.map{|n|
        next if n.nil?
        pitch, duration = *n
        [:note, pitch, {velocity: @default_velocity}]
      }
    end

    @commands
  end

end
end

require 'minitest/autorun'
require_relative '../lib/phrase'

class PhraseTest < MiniTest::Test
  include GenerativeMusic
  def test_insert_note
    p = Phrase.new(:length => 4)
    p.insert_note(0, 'C4', 3)
    p.insert_note(1, 'D4', 1)
    assert_equal [['C4', 3], ['D4', 1], nil, nil], p.notes
  end

  def test_insert_note_increase_length_of_phrase
    p = Phrase.new
    assert_equal 0, p.length

    p.insert_note(0, 'C4', 1)
    assert_equal 1, p.length

    p.insert_note(1, 'D4', 2)
    assert_equal 3, p.length
    assert_equal [['C4', 1], ['D4', 2], nil], p.notes
  end

  def test_play_note_inserts_note_off_command
    midi = MiniTest::Mock.new
    
    p = Phrase.new(velocity: 60)
    p.insert_note(0, 'C4', 1)

    midi.expect(:note, '<midinote>', ['C4', {velocity: 60}])
    p.play(midi, 0)

    midi.expect(:note_off, nil, ['<midinote>'])
    p.play(midi, 1)

    midi.verify 
  end
  
  def test_note_on_and_note_off_collision
    midi = MiniTest::Mock.new
    
    p = Phrase.new(velocity: 60)
    p.insert_note(0, 'C4', 1)
    p.insert_note(1, 'D4', 1)

    midi.expect(:note, '<note1>', ['C4', {velocity: 60}])
    p.play(midi, 0)
  
    midi.expect(:note, '<note2>', ['D4', {velocity: 60}])
    midi.expect(:note_off, nil, ['<note1>'])
    p.play(midi, 1)

    midi.verify 
  end
end

require 'minitest/autorun'
require_relative '../lib/melody'

class MelodyTest < MiniTest::Test
  include GenerativeMusic
  def test_monophonic_no_dynamics
    m = Melody.new({
      0 =>  'C4',
      12 => 'D4',
      16 => '',
      24 => 'E4',
      30 => nil
    })

    expected_notes = {0 => ['C4', 12], 
                      12 => ['D4', 4], 
                      24 => ['E4', 6]}
    assert_equal expected_notes, m.notes
  end
end

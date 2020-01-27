require 'json'
require_relative './rules'

class Config
  FILE = '~/.config/karabiner/karabiner.json'
  PROFILE_NAME = 'Default profile'
  RULE_NAME = 'VLMONK - custom keyboard bindings.'


  RULE_CS = {
    from: { key_code: "caps_lock" },
    to: [
      { set_variable: { name: 'caps_lock_pressed', value: 1 } }
    ]
  }

  RULE_EN = {
    from: { key_code: "left_gui", modifiers: { optional: ["any"] } },
    to: [
      { set_variable: { name: 'caps_lock_pressed', value: 0 } },
      { select_input_source: { language: "en" } }
    ],
    conditions: [
      { name: "caps_lock_pressed", type: "variable_if", value: 1 }
    ]
  }

  RULE_RU = {
    from: { key_code: "right_alt", modifiers: { optional: ["any"] } },
    to: [
      { set_variable: { name: 'caps_lock_pressed', value: 0 } },
      { select_input_source: { language: "ru" } }
    ],
    conditions: [
      { name: "caps_lock_pressed", type: "variable_if", value: 1 }
    ]
  }



  def initialize
    @raw = JSON.parse(File.read(path))
    @profile = @raw['profiles'].find { |p| p['name'] == PROFILE_NAME }
    @profile['complex_modifications']['rules'].delete_if { |r| r['description'] = RULE_NAME }

    @rules = Rules.new RULE_NAME
  end

  def install
    @rules << RULE_CS
    [RULE_EN, RULE_RU].each { |rule| @rules << rule }

    @profile['complex_modifications']['rules'] << @rules.as_json

    puts "install to #{path}"
    File.write(path, JSON.dump(@raw))
  end

  private

  def path
    File.expand_path(FILE)
  end
end
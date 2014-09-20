class DictionaryController < ApplicationController

  def index
    @history = Translation.all
  end

  def interpret
    @prms = params[:interpretation]
    interpretations = $api.lookup_arr(@prms)
    hash = Hash.new
    hash["lang"] = @prms["lang"]
    @translations = Array.new
    interpretations.each do |i|
      hash.clear
      hash["lang"] = @prms["lang"]
      hash = hash.merge(i.to_hash)
      @translations << Translation.new(hash)
    end
    @history = Translation.all
    @translations[0].save
    render 'index'
  end

end
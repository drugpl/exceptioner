class CrashesController < ApplicationController
  def index
    raise Exception.new("Deal with it, bitch")
  end

end

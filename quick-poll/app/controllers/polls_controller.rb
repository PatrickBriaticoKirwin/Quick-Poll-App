class PollsController < ApplicationController
  def index
    @polls = [
      { id: 1, question: "Favorite language?", options: {"Python" => 0, "Ruby" => 0, "JS" => 0} }
    ]
  end
end

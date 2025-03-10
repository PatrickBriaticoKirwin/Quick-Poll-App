class PollsController < ApplicationController
  @@votes = Hash.new(0) # In-memory votes
  @@poll = { id: 1, question: "Favorite language?", options: {"Python" => 0, "Ruby" => 0, "JS" => 0} } # Default poll
  before_action :admin_access, only: [:admin, :update_poll]


  def index
    @polls = [@@poll.merge(options: @@poll[:options].keys.each_with_object({}) { |opt, h| h[opt] = @@votes[opt] })]
    @has_voted = cookies[:voted] == "true" # Pass to view for UI feedback

  end

  def vote

    if cookies[:voted] == "true"
      redirect_to root_path, alert: "You’ve already voted!"
      return
    end

    option = params[:option]
    Rails.logger.info "Received option: #{option.inspect}"
    if option.present? && @@poll[:options].keys.include?(option)
      @@votes[option] += 1
      cookies[:voted] = { value: "true", expires: 1.year.from_now } # Set cookie for 1 year

      Rails.logger.info "Updated votes: #{@@votes.inspect}"
      redirect_to root_path, notice: "Thanks for voting!"
    else
      redirect_to root_path, alert: "Invalid vote!"
    end
  end

  def admin
    @poll = @@poll
    @votes = @@votes
  end

  def update_poll
    new_question = params[:question]
    new_options = params[:options].split(",").map(&:strip) # Expect comma-separated options
    if new_question.present? && new_options.length >= 2
      # Preserve existing votes for options that carry over, reset others
      old_options = @@poll[:options].keys
      new_votes = new_options.each_with_object({}) { |opt, h| h[opt] = @@votes[opt] || 0 }
      @@poll = { id: 1, question: new_question, options: new_votes }
      @@votes = new_votes
      redirect_to admin_path, notice: "Poll updated!"
    else
      redirect_to admin_path, alert: "Need a question and at least 2 options!"
    end
  end

  private

  def admin_access
    redirect_to root_path, alert: "Unauthorized!" unless params[:password] == "secret" # Hardcoded for demo
  end
end

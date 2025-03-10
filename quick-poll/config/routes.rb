


Rails.application.routes.draw do
  root "polls#index"
  get "/polls", to: "polls#index"
  post "/polls/vote", to: "polls#vote"
  get "/admin", to: "polls#admin", as: :admin
  post "/admin/update", to: "polls#update_poll", as: :update_poll
end

# frozen_string_literal: true

UntitledUi::Engine.routes.draw do
  namespace :design_system do
    resources :components, only: [ :index, :show ], param: :id
  end

  root to: "design_system/components#index"
end

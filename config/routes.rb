# frozen_string_literal: true

UntitledUi::Engine.routes.draw do
  namespace :design_system do
    resources :components, only: %i[index show], param: :id do
      member do
        get :playground
      end
    end
  end

  root to: "design_system/components#index"
end

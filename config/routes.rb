# frozen_string_literal: true

UntitledUi::Engine.routes.draw do
  resources :components, only: %i[index show], param: :id,
                          controller: "design_system/components" do
    member do
      get :playground
    end
  end

  root to: "design_system/components#index"
end

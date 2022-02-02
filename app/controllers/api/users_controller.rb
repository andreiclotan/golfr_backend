module Api
  # Controller that handles authorization and user data fetching
  class UsersController < ApplicationController
    include Devise::Controllers::Helpers

    def login
      user = User.find_by('lower(email) = ?', params[:email])

      if user.blank? || !user.valid_password?(params[:password])
        render json: {
          errors: [
            'Invalid email/password combination'
          ]
        }, status: :unauthorized
        return
      end

      sign_in(:user, user)

      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          token: current_token
        }
      }.to_json
    end

    def scores
      scores = Score.where(user_id: params[:id]).includes(:user)
      return unless scores

      serialized_scores = scores.map(&:serialize)
      render json: {
        scores: serialized_scores
      }
    end

    def name
      user = User.find_by(id: params[:id])
      return unless user

      render json: {
        name: user.name
      }
    end
  end
end

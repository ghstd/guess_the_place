class EditorController < ApplicationController
  before_action :authenticate_user!

  def new_story
  end

  def new_lesson
  end

  def create_story
    pp story_params
  end

  def create_lesson
    permitted_params = lesson_params
    p permitted_params

    # ActiveRecord::Base.transaction do
    #   lesson = Lesson.create!(name: permitted_params["name"])

    #   permitted_params["questions"].each do |question|
    #     created_question = lesson.lesson_questions.create!(
    #       content: question["question"],
    #       image: question["image"]
    #     )

    #     question["answers"].each do |answer|
    #       created_question.lesson_answers.create!(content: answer)
    #     end
    #   end
    # end

    #   render json: { message: "Lesson created successfully" }, status: :created
    # rescue ActiveRecord::RecordInvalid => e
    #   # Обработка ошибки
    #   render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def story_params
    params.require(:data).permit(
      :name,
      questions: [
        { coordinates: [] },
        :question,
        :answer,
        { options: [] }
      ]
    )
  end

  def lesson_params
    params.require(:data).permit(
      :name,
      questions: [
        :image,
        :question,
        { answers: [] }
      ]
    )
  end
end

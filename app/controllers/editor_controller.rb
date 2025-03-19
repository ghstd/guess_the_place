class EditorController < ApplicationController
  before_action :authenticate_user!

  def new_story
  end

  def new_lesson
  end

  def create_story
    permitted_params = story_params

    ActiveRecord::Base.transaction do
      story = Story.create!(name: permitted_params["name"], author: current_user.id)

      permitted_params["questions"].each do |question|
        story.story_questions.create!(
          coordinates: question["coordinates"],
          question: question["question"],
          answer: question["answer"],
          options: question["options"]
        )
      end
    end

    render json: { message: "Story created successfully" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create_lesson
    permitted_params = lesson_params

    ActiveRecord::Base.transaction do
      lesson = Lesson.create!(name: permitted_params["name"], author: current_user.id)

      permitted_params["questions"].each do |question|
        created_question = lesson.lesson_questions.create!(
          content: question["question"],
          image: question["image"]
        )

        question["answers"].each do |answer|
          created_question.lesson_answers.create!(content: answer)
        end
      end
    end

      flash[:notice] = "Урок успешно создан!"
      render json: { message: "Lesson created successfully" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Произошла ошибка при создании урока."
      render json: { error: e.message }, status: :unprocessable_entity
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

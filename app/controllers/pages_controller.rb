class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def streets
    all_srteets = [
      "вулиця Тичини",
      "вулиця Бориса Мозолевсько",
      "Моршинська вулиця",
      "Домотканська вулиця",
      "Автопаркова вулиця",
      "Базова вулиця",
      "Роторна вулиця",
      "вулиця Євгена Маланюка",
      "вулиця Василя Грунтенка",
      "вулиця Кирила Осьмака",
      "вулиця Самійла Зборовсько",
      "Космонавтів вулиця",
      "вулиця Івана Багряного"
    ]

    render json: all_srteets.sample(3)
  end
end

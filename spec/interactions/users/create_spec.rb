require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_params) do
    {
      "name" => "Иван",
      "surname" => "Иванов",
      "patronymic" => "Иванович",
      "email" => "ivan@example.com",
      "age" => 30,
      "nationality" => "Russian",
      "country" => "Russia",
      "gender" => "male",
      "interests" => [],
      "skills" => []
    }
  end

  describe "успешное создание пользователя" do
    it "создаёт пользователя при валидных данных" do
      result = Users::Create.run(**valid_params)

      expect(result).to be_valid
      expect(result.result).to be_a(User)
      expect(User.exists?(email: valid_params["email"])).to be_truthy
    end
  end

  describe "неудачное создание пользователя" do
    it "не создаёт пользователя без email" do
      invalid_params = valid_params.merge("email" => "")
      result = Users::Create.run(**invalid_params)

      expect(result).not_to be_valid
      expect(result.errors.full_messages).to include("Email can't be blank")
    end

    it "не создаёт пользователя с возрастом больше 90" do
      invalid_params = valid_params.merge("age" => 95)
      result = Users::Create.run(**invalid_params)

      expect(result).not_to be_valid
      expect(result.errors.full_messages).to include("Age must be less than or equal to 90")
    end

    it "не создаёт пользователя с неверным полом" do
      invalid_params = valid_params.merge("gender" => "other")
      result = Users::Create.run(**invalid_params)

      expect(result).not_to be_valid
      expect(result.errors.full_messages).to include("Gender only male or female")
    end
  end

  describe "обработка интересов и навыков" do
    it "добавляет существующие интересы" do
      interest = Interest.create!(name: "Музыка")
      valid_params["interests"] = [ interest.name ]

      result = Users::Create.run(**valid_params)
      user = result.result

      expect(user.interests).to include(interest)
    end

    it "создаёт новые интересы, если их нет" do
      valid_params["interests"] = [ "Путешествия" ]

      result = Users::Create.run(**valid_params)
      user = result.result

      expect(user.interests.map(&:name)).to include("Путешествия")
    end

    it "добавляет существующие навыки" do
      skill = Skill.create!(name: "Ruby")
      valid_params["skills"] = [ skill.name ]

      result = Users::Create.run(**valid_params)
      user = result.result

      expect(user.skills).to include(skill)
    end

    it "создаёт новые навыки, если их нет" do
      valid_params["skills"] = [ "Python" ]

      result = Users::Create.run(**valid_params)
      user = result.result

      expect(user.skills.map(&:name)).to include("Python")
    end
  end
end

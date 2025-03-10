module Users
  class Create < ActiveInteraction::Base
    string :surname
    string :name
    string :patronymic
    string :email
    integer :age
    string :nationality
    string :country
    string :gender
    array :interests, default: []
    array :skills, default: []

    validates :surname, :name, :patronymic, :email, :nationality, :country, :gender, presence: true
    validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
    validate :validate_email_uniqueness
    validate :validate_gender

    def execute
      user = User.new(
        surname: surname,
        name: name,
        patronymic: patronymic,
        email: email,
        age: age,
        nationality: nationality,
        country: country,
        gender: gender
      )

      unless user.save
        errors.merge!(user.errors)
        return
      end

      attach_interests(user)
      attach_skills(user)

      user
    end

    private

    def validate_email_uniqueness
      errors.add(:email, "not unique") if User.exists?(email: email)
    end

    def validate_gender
      errors.add(:gender, "only male or female") unless %w[male female].include?(gender)
    end

    def attach_interests(user)
      interests.compact_blank.each do |interest_name|
        interest = Interest.find_or_create_by(name: interest_name)
        user.interests << interest unless user.interests.include?(interest)
      end
    end

    def attach_skills(user)
      skills.compact_blank.each do |skill_name|
        skill = Skill.find_or_create_by(name: skill_name)
        user.skills << skill unless user.skills.include?(skill)
      end
    end
  end
end

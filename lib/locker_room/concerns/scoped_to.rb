module LockerRoom
  module ScopedTo
    def scoped_to(team)
      where(:team_id => team.id)
    end
  end
end


class IshManager::Ability
  include ::CanCan::Ability

  def initialize user 

    #
    # signed in user
    #
    unless user.blank?

      # role manager
      if user.profile && [ :manager, :admin ].include?( user.profile.role_name )    

        can [ :create_newsitem, :show, :new_feature, :create_feature ], ::City

        can [ :new ], ::Feature

        can [ :cities_index, :home, :sites_index, :venues_index ], ::Manager

        can [ :new ], Newsitem

        can [ :new, :create ], Report

        can [ :show, :edit, :update, :create_newsitem, :new_feature, :create_feature ], ::Site do |site|
          !site.is_private && !site.is_trash
        end
        can [ :manage ], IshModels::StockWatch

        # can [ :new_feature, :create_feature ], ::Tag

      end

      if user.profile && user.profile.sudoer?
        can :manage, :all
        can [ :home ], ::Manager
        can :destroy, ::Photo
      end

      can [ :show ], ::Gallery do |gallery|
        gallery.user == user
      end
      
    end
    #
    # anonymous user
    #
    user ||= ::User.new
    
    can [ :show ], ::Gallery do |gallery|
      gallery.is_public
    end

    can [ :show ], ::Report do |report|
      report.is_public
    end
    
  end
end

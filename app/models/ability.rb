class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # guest user (not logged in)

    #for guest or bandless musician
    can :read, :all

    #for signed-in user
    can :create, Band if user
    @user.memberships.each { |membership| send(membership.role, membership) }
  end

  def invited(membership)
    can :convert_to_member, Membership, :id => membership.id
    can :change_instrument, Membership, :id => membership.id
    can :destroy, Membership, :id => membership.id
  end

  def member(membership)
    invited(membership)
  end

  def manager(membership)
    member(membership)
    can :update, Band, :id => membership.band_id
    can :destroy, Membership, :band_id => membership.band_id
    cannot :destroy, Membership, :band_id => membership.band_id, :role => ["manager", "owner"]
    can :destroy, Membership, :band_id => membership.band_id, :id => membership.id
    can :change_instrument, Membership, :band_id => membership.band_id
    can :create, Membership, :band_id => membership.band_id # invite a user or create an open position
    #cannot :create, Membership, :band_id => membership.band_id, :user_id => Membership.where(:band_id => membership.band_id).map(&:user_id).delete_if{ |id| id.nil? || id<=0 }
  end

  def owner(membership)
    manager(membership)
    can :destroy, Band, :id => membership.band_id
    can :destroy, Membership, :band_id => membership.band_id
    cannot :destroy, Membership, :id => membership.id unless Membership.where(band_id: membership.band_id, role: "owner").count > 1
    can :convert_to_member, Membership, :band_id => membership.band_id, :role => ["manager", "owner"] #including other owners!
    #cannot :convert_to_member, Membership, :band_id => membership.band_id, :role => ["invited", "open", nil]
    cannot :convert_to_member, Membership, :id => membership.id unless Membership.where(band_id: membership.band_id, role: "owner").count > 1
    can :convert_to_manager, Membership, :band_id => membership.band_id, :role => ["member", "owner"] #including other owners!
    #cannot :convert_to_manager, Membership, :band_id => membership.band_id, :role => ["invited", "open", nil]
    cannot :convert_to_manager, Membership, :id => membership.id unless Membership.where(band_id: membership.band_id, role: "owner").count > 1
    can :convert_to_owner, Membership, :band_id => membership.band_id, :role => ["member", "manager"]
    #cannot :convert_to_owner, Membership, :band_id => membership.band_id, :role => ["invited", "open", nil]
  end
end
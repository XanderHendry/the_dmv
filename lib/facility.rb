require 'date'
class Facility
  attr_reader :name,
              :address,
              :phone, 
              :services,
              :registered_vehicles,
              :collected_fees

  def initialize(facility_details)
    @name = facility_details[:name]
    @address = facility_details[:address]
    @phone = facility_details[:phone]
    @services = []
  end
  
  def add_service(service)
    self.collected_fees_helper
    if service == 'Vehicle Registration'
      self.register_vehicle_helper
    end
    @services << service
  end

  def registered_vehicles
    self.register_vehicle_helper
    @registered_vehicles
  end

  def collected_fees
    self.collected_fees_helper
    @collected_fees
  end

  def register_vehicle_helper
    if @registered_vehicles.nil?
      @registered_vehicles = []
    end
  end
  
  def collected_fees_helper
    if @collected_fees.nil?
      @collected_fees = 0
    end
  end

  def register_vehicle(vehicle)
    if @services.include?('Vehicle Registration')
      vehicle.registration_date = Date.today
      if vehicle.antique?
        vehicle.plate_type = :antique
        @collected_fees += 25
      elsif vehicle.engine == :ev
        vehicle.plate_type = :ev
        @collected_fees += 200
      else
        vehicle.plate_type = :regular
        @collected_fees += 100
      end
      @registered_vehicles << vehicle
    end
  end

  def administer_written_test(registrant)
    if @services.include?('Written Test')
      if registrant.permit? && registrant.age > 15
        registrant.license_data[:written] = true
      else
        false
      end
    else
      false
    end
  end

  def administer_road_test(registrant)
    if @services.include?('Road Test') && registrant.license_data[:written] == true
      registrant.license_data[:license] = true
    else
      false
    end 
  end

  def renew_license(registrant)
    if @services.include?('Renew License') && registrant.license_data[:license] == true
      registrant.license_data[:renewed] = true
    else
      false
    end
  end
end

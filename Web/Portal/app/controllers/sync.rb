require_relative("../../../../arbitrMED")

Portal::App.controllers :sync do
#kontrolér pro provádění synchronizace dat
  layout "main"
  get :index do
    @tariffs = Tariff.all
    render "sync/index"
  end

  post :sync,  :map =>"sync/*model" do
    type = params[:model]
    case type
      when "csv"
        file = params["data"]
        logger.debug(params)
        soubor = file[:tempfile].path
        sw = Array.new
        lF = Hash.new
        lF["LoadCSV"] = Hash.new
        lF["LoadCSV"]["store"] =  "users"
        lF["LoadCSV"]["file"] = soubor
        lF["LoadCSV"]["type"] = "ssv"
        sw.push(lF)
        app = ArbitrMED.new
        app.loadRecipeYAML(sw)
        app.cook()
        data = app.getOutput
        data.each do |zaznam|
          sim_serial = zaznam["sériové číslo sim karty"]
          mobilephone = zaznam["telefonní číslo"]
          surname = zaznam["příjmení"]
          name = zaznam["jméno"]
          department = zaznam["odbor"]
          tarif = zaznam["tarif"]

          sim = Sim.find_by_serial(sim_serial)
          if sim.nil? then
            sim = Sim.new
          end

          sim.serial = sim_serial
          sim.phone = mobilephone
          sim.save

          persona = Persona.find_by_surname(surname)
          if(persona.nil?) then
            persona = Persona.new
          else
            #osoba uz existuje, musime osetrit jmenovce (pozdeji dle username)
            if persona.is_a?(Array) then
              persona.each do |per|
                if ((per.name == name) and (per.surname == surname) and (per.department == department) ) then
                  persona = per
                  break
                end
              end
              #nenasli jsme schodu -> vyrobime noveho
              persona = Persona.new
            end
          end

          persona.name = name
          persona.surname = surname
          persona.department = department
          persona.save

          #mame SIM a Personu -> zbyva balicek
          package = Package.find_by_name(tarif)
          if(package.nil?) then
            package = Package.new
            package.name = tarif
            package.save
          end
          #mame i balicek -> provedeme spojeni
          mobil = Mobile.new
          mobil.persona = persona
          mobil.sim = sim
          mobil.package = package
          mobil.save
        end

      end
    render "sync/index"
  end
end
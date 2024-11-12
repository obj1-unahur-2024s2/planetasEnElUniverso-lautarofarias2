class Persona {
  var property monedas = 20
  var edad

  method edad() = edad
  method recursos() = monedas
  method esDestacada() = edad.between(18, 65) or self.recursos() > 30

  method gastarMonedas(cantidad) {
    monedas -= cantidad
  }
  method cumplirAnios() {
    edad =+ 1
  }
  method trabajarEn(unPlaneta,unTiempo)
}

class Construccion {
  method valor() 
}

class Muralla inherits Construccion{
  var longitud

  method longitud() = longitud
  override method valor() = longitud * 10
}

class Museo inherits Construccion{
  var superficieCubierta
  var indiceDeImportancia

  method indiceDeImportancia() = indiceDeImportancia
  method superficie() = superficieCubierta
  override method valor() = superficieCubierta * indiceDeImportancia
}

class Planeta {
  const property personas = []
  const property construcciones = []

  method delegacionDiplomatica() {
    const delegacion = self.habitantesDestacados()
    if(! delegacion.contains(self.habitanteConMasRecursos())){
    delegacion.add(self.habitanteConMasRecursos())
    }
    return delegacion
  }

  method esValioso() = construcciones.sum({c => c.valor()}) > 100

  method habitantesDestacados() = personas.filter({p => p.esDestacada()})

  method habitanteConMasRecursos() = personas.max({p => p.recursos()})

  method construir(unaConstruccion){
    construcciones.add(unaConstruccion)
  }
}

class Productor inherits Persona{
  const property tecnicas = []

  method initialize() {
    tecnicas.clear()
    tecnicas.add("cultivar")
  }

  override method recursos() = super() * tecnicas.size()

  override method esDestacada() = super() or tecnicas.size() > 5

  method realizar(unaTecnica,unTiempo){
    if(tecnicas.contains(unaTecnica)){
      monedas += 3*unTiempo
    }
    else{
      monedas -= 1
    }
  }

  method aprenderUnaTecnica(unaTecnica) {
    tecnicas.add(unaTecnica)
  }

  override method trabajarEn(unPlaneta,unTiempo){
    if(unPlaneta.personas().contains(self)){
      self.realizar(tecnicas.last(), unTiempo)
    }
  }
}

class Constructor inherits Persona {
  const property construccionesRealizadas = []
  var property region

  override method recursos() = super() + 10 * construccionesRealizadas.size()

  override method esDestacada() = construccionesRealizadas.size() > 5

  override method trabajarEn(unPlaneta, unTiempo){
    if(region == "montania"){
      const muralla = new Muralla(longitud = unTiempo * 0.5)
      unPlaneta.construir(muralla)
      monedas -= 5
    }
    if(region == "costa"){
      const museo = new Museo(superficieCubierta=unTiempo, indiceDeImportancia=1)
      unPlaneta.construir(museo)
      monedas -= 5
    }
    if(region == "llanura"){
      if(!self.esDestacada()){
      const muralla = new Muralla(longitud = unTiempo * 0.5)
      unPlaneta.construir(muralla)
      monedas -= 5
      }
      else{
      const museo = new Museo(superficieCubierta=unTiempo, indiceDeImportancia= self.nivelDeImportancia())
      unPlaneta.construir(museo)
      monedas -= 5
      }

    }
    if(region == "selva"){
      if(self.inteligencia() > 120){
      const museo = new Museo(superficieCubierta=unTiempo * 2, indiceDeImportancia= 5)
      unPlaneta.construir(museo)
      monedas -= 5
      }
      else{
      const muralla = new Muralla(longitud = unTiempo * 2)
      unPlaneta.construir(muralla)
      monedas -= 5
      }
    }
  }

  method nivelDeImportancia() =
    if(self.recursos()>50){
       5
      }
    else{
      self.recursos() * 0.1
      }
  method inteligencia() = self.recursos() * construccionesRealizadas.size() 
}

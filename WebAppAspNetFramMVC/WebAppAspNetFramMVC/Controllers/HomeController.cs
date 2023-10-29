using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebAppAspNetFramMVC.Models;

namespace WebAppAspNetFramMVC.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult TodosLosPaquetes()
        {
            MantenimientoPaquete mp = new MantenimientoPaquete();
            return View(mp.RecuperarTodosLosPaquetes());
        }

        public ActionResult PaquetesEnviadosProvincia() 
        {
            MantenimientoPaquete mp = new MantenimientoPaquete();
            return View(mp.RecuperarLosPaquetesEnviadosAUnaProvincia("8080"));
        }

        public ActionResult PaquetePorCodigo()
        {
            MantenimientoPaquete mp = new MantenimientoPaquete();
            return View(mp.informacionDeUnPaquetePorCodigo("53434"));
        }
        public ActionResult ConductoresCondujeronCamiones() 
        {
            MantenimientoPaquete mp = new MantenimientoPaquete();
            return View( mp.conductoresConducenCamionesPorPlaca("FK-1010") );
        }
    }
}
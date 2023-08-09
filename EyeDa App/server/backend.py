from flask import Flask, request, jsonify
import arcgis
import json
from dotenv import load_dotenv
import os

load_dotenv()
arcgis_token = os.getenv('arcgis_token')

app = Flask(__name__)


#http://127.0.0.1:5000/dev?startx=-93.43656506493119&starty=44.86055869949538&endx=-93.47820240954265&endy=44.85744946080268
@app.route('/dev', methods=['GET'])
def dev():
    startx = request.args.get('startx') 
    starty = request.args.get('starty')
    endx = request.args.get('endx')
    endy = request.args.get('endy')
    #later - add support for stops, for now this is fine
    try:
        startx = float(startx)
        starty = float(starty)
        endx = float(endx)
        endy = float(endy)
    except ValueError:
        return jsonify("Invalid data type"), 400
    except TypeError:
        return jsonify("Null data"), 400
    
    
    #stops = "-93.43656506493119,44.86055869949538;-93.47820240954265,44.85744946080268"
    stops = f"{startx},{starty};{endx},{endy}"
    

    portal = arcgis.GIS("https://www.arcgis.com", api_key=arcgis_token)
    route = arcgis.network.RouteLayer(portal.properties.helperServices.route.url,
                                    gis=portal)
    result = route.solve(stops=stops,
                        start_time="now",
                        return_directions=True,
                        directions_language="en")
    return jsonify(result)

@app.route('/route', methods=['GET'])
def get_route():    
    
    startx = request.args.get('startx') 
    starty = request.args.get('starty')
    endx = request.args.get('endx')
    endy = request.args.get('endy')
    #later - add support for stops, for now this is fine
    try:
        startx = float(startx)
        starty = float(starty)
        endx = float(endx)
        endy = float(endy)
    except ValueError:
        return jsonify("Invalid data type"), 400
    except TypeError:
        return jsonify("Null data"), 400
    
    
    #stops = "-93.43656506493119,44.86055869949538;-93.47820240954265,44.85744946080268"
    stops = f"{startx},{starty};{endx},{endy}"
    

    portal = arcgis.GIS("https://www.arcgis.com", api_key=arcgis_token)
    route = arcgis.network.RouteLayer(portal.properties.helperServices.route.url,
                                    gis=portal)
    result = route.solve(stops=stops,
                        start_time="now",
                        return_directions=True,
                        directions_language="en")

    path0 = result["routes"]["features"][0]
    route_coordinates = path0["geometry"]
    #print(json.dumps(route_coordinates, sort_keys=True, indent=4))
    
    return jsonify(route_coordinates)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True) #when production, make false
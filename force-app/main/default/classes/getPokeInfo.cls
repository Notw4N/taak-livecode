public without sharing class getPokeInfo {
    public class PokeInfo {
        public string name {get; set;}
        public string url {get; set;}
    }

    public static String getPokemonApiInfo (String endpoint){
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        HttpResponse res = h.send(req);
        return res.getBody();
    }

    public static List<PokeInfo> parsePokeInfo(String jsonString) {
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        return (PokeInfo)jsonMap.get('results');  
    }

    public string getNextURL (String jsonString){
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        return (String)jsonMap.get('next');
    }
}
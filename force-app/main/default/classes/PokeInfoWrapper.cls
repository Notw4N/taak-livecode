public class PokeInfoWrapper {
    public List<Result> results;
    //Ajustei o nome da class para 'Result', antes havia demonimado como 'PokeInfo', respeitando a tag do JSON. 
    //Só me toquei disso depois que eu criei a classe wrapper.
    public class Result {
        public string name;
        public string url;
    }
}
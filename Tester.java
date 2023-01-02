import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;
import java.util.regex.Pattern;

public class Tester {

    public static void main(String[] args) {
         int executed = executeTests("result1.txt",9);
         System.out.println("9x9 OK tests executed: " + executed);
        executed = executeTests("result2.txt",4);
        System.out.println("4x4 OK tests executed: " + executed);
        executed = executeTestsBigGrid("result3.txt",16);
        System.out.println("16x16 OK tests executed: " + executed);
    }

    /**
     * Checks if solution is correct, if any is not, program ends with exit code 1 and prints the grid that failed.
     */
    public static int executeTests(String filename, int GRIS_SIZE){
        ArrayList<String> arr = readFile(filename);
        arr.stream().forEach(solution -> {
            int grid[][] = converter(solution,GRIS_SIZE);
            if(!checkIfSolutionisOK(grid,GRIS_SIZE)){
                System.out.println("incorrect : " + solution);
                System.exit(1);
            }
        });
        return arr.size();
    }
    public static int executeTestsBigGrid(String filename, int GRIS_SIZE){
        ArrayList<String> arr = readFile(filename);
        arr.stream().forEach(solution -> {
            int grid[][] = converterBiggerNum(solution,GRIS_SIZE);
            if(!checkIfSolutionisOK(grid,GRIS_SIZE)){
                System.out.println("incorrect : " + solution);
                System.exit(1);
            }
        });
        return arr.size();
    }

    public static ArrayList<String> readFile(String filename){
        ArrayList<String> arr = new ArrayList<>();
        try {
            File myObj = new File(filename);
            Scanner myReader = new Scanner(myObj);
            while (myReader.hasNextLine()) {
                String data = myReader.useDelimiter("STOP").next();
                arr.add(data);
            }
            myReader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        return arr;
    }


    static void getRandomForRacket(int grid[][],int GRID_SIZE, int matrixNum){
        System.out.printf("(define matrix%d\n" +
                "   '(",matrixNum);
        for(int i = 0; i<GRID_SIZE;i++){
            System.out.printf("( ");
            for(int j= 0;j<GRID_SIZE;j++){
                System.out.printf("%d ",grid[i][j]);
            }
            System.out.println(" )");
        }
        System.out.println("))");
    }
    private static void clearNumbersAtRandomPositions(int grid[][], int GRID_SIZE){
        Random random = new Random(System.currentTimeMillis());
        for(int i = 0; i<GRID_SIZE; i++){
            for(int j = 0; j<GRID_SIZE; j++){
                int randNum = random.nextInt(9) + 1;

                if(randNum % 2 == 1) grid[i][j] = 0;
            }
        }
    }

    public static int[][] generateGridNumbers(int GRID_SIZE){
        int grid[][] = new int[GRID_SIZE][GRID_SIZE];
        setNonCollidingNumbers(grid,GRID_SIZE);
        boolean solved = solveSudoku(grid,GRID_SIZE);
        clearNumbersAtRandomPositions(grid,GRID_SIZE);
        return grid;
    }

    //Key function used to solve sudoku grid
    private static boolean solveSudoku(int grid[][], int GRID_SIZE) {
        for (int rowIndex = 0; rowIndex < GRID_SIZE; rowIndex++) {
            for (int columnIndex = 0; columnIndex < GRID_SIZE; columnIndex++) {
                if (grid[rowIndex][columnIndex] == 0) {
                    for (int num = 1; num <= GRID_SIZE; num++) {

                        if (numIsValid(num, grid, rowIndex, columnIndex,GRID_SIZE)) {
                            grid[rowIndex][columnIndex] = num;
                            if (solveSudoku(grid,GRID_SIZE)) return true;
                            else grid[rowIndex][columnIndex] = 0;
                        }
                    }
                    return false;
                }
            }
        }
        return true;
    }

    private static void setNonCollidingNumbers(int grid[][], int GRID_SIZE){
        Random random = new Random(System.currentTimeMillis());
        int randNum = random.nextInt(9) + 1;
        for(int i = 0; i<GRID_SIZE/(int)(Math.sqrt(GRID_SIZE)); i++){
            grid[i*(int)(Math.sqrt(GRID_SIZE))][i*(int)(Math.sqrt(GRID_SIZE))] = randNum;
        }
    }
    /**
     * @param grid - array of integers [row index][column index]
     * @return true - solution OK, false - solution not correct
     */
    public static boolean checkIfSolutionisOK(int grid[][], int size) {
        for (int rowIndex = 0; rowIndex < size; rowIndex++) {
            for (int columnIndex = 0; columnIndex < size; columnIndex++) {
                if (!numIsValid(grid[rowIndex][columnIndex], grid, rowIndex, columnIndex,size)) {
                    System.out.println(rowIndex + " " + columnIndex);
                    return false;
                }
            }
        }
        return true;
    }
    protected static boolean numIsValid(int num, int grid[][], int rowIndex, int columnIndex, int size) {
        return !containsInRow(num, grid, rowIndex, columnIndex,size)
                && !containsInColumn(num, grid, rowIndex, columnIndex,size)
                && !containsInSquare(num, grid, rowIndex, columnIndex,size);
    }

    protected static boolean containsInRow(int num, int grid[][], int rowIndex, int columnIndex, int size) {

        for (int i = 0; i < size; i++) {
            if (grid[rowIndex][i] == num && i != columnIndex) return true;
        }

        return false;
    }

    protected static boolean containsInColumn(int num, int grid[][], int rowIndex, int columnIndex, int size) {

        for (int i = 0; i < size; i++) {
            if (grid[i][columnIndex] == num && i != rowIndex) return true;
        }
        return false;
    }

    protected static boolean containsInSquare(int num, int grid[][], int rowIndex, int columnIndex, int GRID_SIZE) {
        int sqRow = rowIndex - rowIndex % (int) (Math.sqrt(GRID_SIZE));
        int sqCol = columnIndex - columnIndex % (int)(Math.sqrt(GRID_SIZE));

        for (int i = 0; i < (int)(Math.sqrt(GRID_SIZE)); i++) {
            for (int j = 0; j < (int)(Math.sqrt(GRID_SIZE)); j++) {
                if (grid[sqRow + i][sqCol + j] == num && sqRow + i != rowIndex && sqCol + j != columnIndex) return true;
            }
        }
        return false;
    }
    public static int [][] converterBiggerNum(String racketOutput ,int size){
        racketOutput = racketOutput.replace("(","").replace(")","")
                .replace("  ","\n").replace("#t","")
                .replace(" ","\n").replace("'","").replace("\n\n","\n");
        int grid [][] = new int[size][size];
        ArrayList<Integer> arrInt = new ArrayList<>();

        while(!racketOutput.equals("")){
            if(racketOutput.startsWith("\n")){
                racketOutput = racketOutput.replaceFirst("\n","");
            }
            int i = 0;
            String acc = "";
            while(i< racketOutput.length() && racketOutput.charAt(i) != '\n'){
                acc+=String.valueOf(racketOutput.charAt(i));
                i++;
            }
            if(!acc.equals("")){
                arrInt.add(Integer.parseInt(acc));
            }

            if(i < racketOutput.length()){
                racketOutput = racketOutput.substring(i);
            }else{
                break;
            }

        }
        int arrIndx = 0;
        for(int i = 0; i<size; i++){
            for(int j = 0; j<size;j++){
                grid[i][j] = arrInt.get(arrIndx++);
            }
        }
        return grid;
    }
    public static int [][] converter(String racketOutput ,int size){
        racketOutput = racketOutput.replace("(","").replace(")","")
                .replace("  ","").replace("\n","").replace("#t","")
                .replace(" ","").replace("'","");
        int grid [][] = new int[size][size];
        int indx = 0;
        for(int i = 0; i<size; i++){
            for(int j = 0; j<size;j++){
                String num = String.valueOf(racketOutput.charAt(indx++));
                int val = Integer.parseInt(num);
                grid[i][j] = val;
            }
        }
        return grid;
    }

}
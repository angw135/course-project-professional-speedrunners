package app.view.cmd_main;

import app.adapter.controller.GenericController;

public class Main {
    public static void main(String[] args) {
        GenericController controller = new GenericController();
        SystemInputOutput userInteractor = new SystemInputOutput();
        controller.run(userInteractor);
    }
}

package com.dexterous.flutterlocalnotifications.models.styles;

import androidx.annotation.Keep;

@Keep
public class ForegroundStyleInformation extends DefaultStyleInformation {
    public String value;
    public String image;
    public String button;
    public String logo;

    public ForegroundStyleInformation(String value, String image, String button, String logo) {
        super(false, false);
        this.value = value;
        this.image = image;
        this.button = button;
        this.logo = logo;
    }
}

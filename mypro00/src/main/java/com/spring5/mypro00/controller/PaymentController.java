package com.spring5.mypro00.controller;

import java.io.IOException;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

import lombok.Value;

@Controller
public class PaymentController {

    private final IamportClient iamportClient;

    public PaymentController() {
        this.iamportClient = new IamportClient("7136103673717160",
                "uFJVzx90BBXPZSbnqpGxlxPGMbnSIXiVkJGjsy2Z9BNrJASb9zPS2kFib1VZ4z6yqRkE3pIzY9rvQ33u");
    }
    

    @ResponseBody
    @RequestMapping("/verify/{imp_uid}")
    public IamportResponse<Payment> paymentByImpUid(@PathVariable("imp_uid") String imp_uid)
            throws IamportResponseException, IOException {
        return iamportClient.paymentByImpUid(imp_uid);
    }

}



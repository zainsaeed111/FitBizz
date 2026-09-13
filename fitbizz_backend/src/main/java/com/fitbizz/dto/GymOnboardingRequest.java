package com.fitbizz.dto;

import java.util.List;

public class GymOnboardingRequest {

    private String gymName;
    private String gymCode;
    private String ownerName;
    private String ownerPhone;
    private String ownerEmail;
    private String gymAddress;
    private String city;
    private String cnic;
    private String gymAreaSqFt;
    private Integer numberOfBranches = 1;
    private List<BranchDto> branches;
    private Boolean enableTrial = true;
    private Integer trialDays = 15;
    private Integer subscriptionDurationDays = 30;
    private String planName = "Pro Business Plan";

    public static class BranchDto {
        private String name;
        private String code;
        private String address;
        private String phone;

        public BranchDto() {}

        public BranchDto(String name, String code, String address, String phone) {
            this.name = name;
            this.code = code;
            this.address = address;
            this.phone = phone;
        }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getCode() { return code; }
        public void setCode(String code) { this.code = code; }

        public String getAddress() { return address; }
        public void setAddress(String address) { this.address = address; }

        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
    }

    public GymOnboardingRequest() {}

    public String getGymName() { return gymName; }
    public void setGymName(String gymName) { this.gymName = gymName; }

    public String getGymCode() { return gymCode; }
    public void setGymCode(String gymCode) { this.gymCode = gymCode; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getOwnerPhone() { return ownerPhone; }
    public void setOwnerPhone(String ownerPhone) { this.ownerPhone = ownerPhone; }

    public String getOwnerEmail() { return ownerEmail; }
    public void setOwnerEmail(String ownerEmail) { this.ownerEmail = ownerEmail; }

    public String getGymAddress() { return gymAddress; }
    public void setGymAddress(String gymAddress) { this.gymAddress = gymAddress; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getCnic() { return cnic; }
    public void setCnic(String cnic) { this.cnic = cnic; }

    public String getGymAreaSqFt() { return gymAreaSqFt; }
    public void setGymAreaSqFt(String gymAreaSqFt) { this.gymAreaSqFt = gymAreaSqFt; }

    public Integer getNumberOfBranches() { return numberOfBranches; }
    public void setNumberOfBranches(Integer numberOfBranches) { this.numberOfBranches = numberOfBranches; }

    public List<BranchDto> getBranches() { return branches; }
    public void setBranches(List<BranchDto> branches) { this.branches = branches; }

    public Boolean getEnableTrial() { return enableTrial; }
    public void setEnableTrial(Boolean enableTrial) { this.enableTrial = enableTrial; }

    public Integer getTrialDays() { return trialDays; }
    public void setTrialDays(Integer trialDays) { this.trialDays = trialDays; }

    public Integer getSubscriptionDurationDays() { return subscriptionDurationDays; }
    public void setSubscriptionDurationDays(Integer subscriptionDurationDays) { this.subscriptionDurationDays = subscriptionDurationDays; }

    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }
}

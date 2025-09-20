//
//  EmailStepView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct EmailStepView: View {
    @Binding var userType: UserType?
    @Binding var email: String
    @Binding var showCodeField: Bool
    @Binding var code: String
    @Binding var showMismatchModal: Bool
    @Binding var showDuplicateModal: Bool
    @Binding var termsAgreed: Bool
    @Binding var privacyAgreed: Bool
    var onNext: () -> Void
    var onSend: () -> Void
    var onDuplicateLogin: () -> Void
    var onDuplicateFindPassword: () -> Void

    @StateObject private var vm = EmailStepViewModel()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @FocusState private var emailFocused: Bool
    @FocusState private var codeFocused: Bool
    @State private var activeAlert: AlertType?
    @State private var showTermsSheet = false
    @State private var showPrivacySheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("사용자 유형").foregroundStyle(.white.opacity(0.9)).bold()
            HStack(spacing: 10) {
                PrimaryActionButton(title: "일반 사용자", titleFont: .system(size: 16, weight: .semibold), systemImage: "person", height: 28) { userType = .normal }
                    .opacity(userType == .normal ? 1.0 : (userType == nil ? 0.6 : 0.8))
                PrimaryActionButton(title: "딜러", titleFont: .system(size: 16, weight: .semibold), systemImage: "car.2", height: 28) { userType = .dealer }
                    .opacity(userType == .dealer ? 1.0 : (userType == nil ? 0.6 : 0.8))
            }

            if userType != nil {
                VStack(alignment: .leading, spacing: 10) {
                    AgreementRow(isOn: $termsAgreed, title: "서비스 이용 약관에 동의합니다.") {
                        showTermsSheet = true
                    }
                    AgreementRow(isOn: $privacyAgreed, title: "개인정보 수집 및 이용에 동의합니다.") {
                        showPrivacySheet = true
                    }
                }
                .padding(.top, 4)

                Text("이메일").foregroundStyle(.white.opacity(0.9)).bold()
                HStack(spacing: 8) {
                    OutlinedInputField(text: $email, placeholder: "이메일을 입력하세요", systemImage: "envelope", isSecure: false, keyboardType: .emailAddress, focus: $emailFocused)
                    let expired = showCodeField && vm.remainingSeconds == 0
                    PrimaryActionButton(title: expired ? "재전송하기" : "인증하기", titleFont: .system(size: 16, weight: .semibold), height: 22, isDisabled: email.isEmpty || !(termsAgreed && privacyAgreed)) {
                        showCodeField = true
                        showMismatchModal = false
                        vm.startTimer()
                        vm.resetExpiredNotice()
                        code = ""
                        onSend()
                        emailFocused = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { codeFocused = true }
                    }
                    .frame(width: 100)
                }
                if showCodeField {
                    Text("이메일 인증번호").foregroundStyle(.white.opacity(0.9)).bold()
                    OutlinedInputField(text: $code, placeholder: "인증번호", systemImage: "number", isSecure: false, keyboardType: .numberPad, focus: $codeFocused)
                        .onChange(of: code) { _, newValue in
                            let digits = newValue.filter { $0.isNumber }
                            if digits != newValue { code = digits }
                            vm.resetExpiredNotice()
                        }
                    // 남은 시간 표시 (3분 카운트다운) - 우측 정렬
                    HStack {
                        Spacer()
                        Image(systemName: "timer")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(vm.remainingSeconds > 0 ? .white.opacity(0.7) : .red)
                        Text(vm.timeString())
                            .font(.caption.bold())
                            .foregroundStyle(vm.remainingSeconds > 0 ? .white.opacity(0.7) : .red)
                    }
                    .padding(.top, 2)
                    
                    let isExpired = showCodeField && vm.remainingSeconds == 0
                    if vm.showExpiredNotice && isExpired {
                        Text("인증 시간이 만료되었습니다. 재전송 후 다시 입력해주세요.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    if !code.isEmpty {
                        PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32, isDisabled: !(termsAgreed && privacyAgreed)) {
                            if isExpired {
                                vm.markExpired()
                                code = ""
                            } else {
                                onNext()
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: showCodeField) { _, newValue in
            if newValue {
                vm.startTimer()
                codeFocused = true
            } else {
                vm.stopTimer()
            }
        }
        .onReceive(ticker) { _ in
            guard showCodeField else { return }
            vm.tick()
        }
        .onAppear { emailFocused = true }
        .onChange(of: showMismatchModal) { _, newValue in
            if newValue {
                vm.stopTimer()
                activeAlert = .mismatch
            } else if activeAlert == .mismatch {
                activeAlert = nil
            }
        }
        .onChange(of: showDuplicateModal) { _, newValue in
            if newValue {
                vm.stopTimer()
                showCodeField = false
                activeAlert = .duplicate
            } else if activeAlert == .duplicate {
                activeAlert = nil
            }
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .mismatch:
                return Alert(
                    title: Text("인증번호가 일치하지 않습니다."),
                    message: Text("받으신 인증번호를 다시 확인한 뒤 입력해주세요."),
                    dismissButton: .default(Text("다시 입력하기")) {
                        showMismatchModal = false
                        code = ""
                        vm.startTimer()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            codeFocused = true
                        }
                    }
                )
            case .duplicate:
                return Alert(
                    title: Text("이미 가입된 이메일입니다."),
                    message: Text("기존 계정으로 로그인하거나 비밀번호를 찾을 수 있습니다."),
                    primaryButton: .default(Text("다시 로그인하기")) {
                        showDuplicateModal = false
                        onDuplicateLogin()
                    },
                    secondaryButton: .default(Text("비밀번호를 찾으시겠습니까?")) {
                        showDuplicateModal = false
                        onDuplicateFindPassword()
                    }
                )
            }
        }
        .sheet(isPresented: $showTermsSheet) {
            AgreementDetailView(title: "서비스 이용 약관")
        }
        .sheet(isPresented: $showPrivacySheet) {
            AgreementDetailView(title: "개인정보 수집 및 이용")
        }
    }
}

private enum AlertType: Identifiable {
    case mismatch
    case duplicate

    var id: Int {
        switch self {
        case .mismatch: return 0
        case .duplicate: return 1
        }
    }
}

private struct AgreementRow: View {
    @Binding var isOn: Bool
    let title: String
    let onDetail: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: { isOn.toggle() }) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isOn ? AppColors.brandOrange : .white.opacity(0.8))
            }
            .buttonStyle(.plain)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDetail) {
                Text("보기")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppColors.brandOrange)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct AgreementDetailView: View {
    let title: String

    private var bodyText: String {
        switch title {
        case "서비스 이용 약관":
            return TermsContent.service
        case "개인정보 수집 및 이용":
            return TermsContent.privacy
        default:
            return TermsContent.service
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(bodyText)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
            }
            .background(AppColors.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

private enum TermsContent {
    static let service = """
캠픽 서비스 이용 약관

제1조(목적)
이 약관은 캠핑카 중고 거래 플랫폼인 캠픽(이하 "회사")가 제공하는 모바일 및 온라인 서비스(이하 "서비스")의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조(용어의 정의)
1. "회원"은 본 약관에 동의하고 회사가 제공하는 서비스를 이용하는 자를 말합니다.
2. "판매자"는 캠핑카 또는 관련 물품을 판매할 목적으로 서비스를 이용하는 회원을 말합니다.
3. "구매자"는 판매자가 등록한 매물을 조회하거나 구매하려는 회원을 말합니다.
4. "매물"은 판매자가 서비스에 등록한 캠핑카, 캠핑 트레일러 등 중고 상품을 의미합니다.

제3조(약관의 게시와 개정)
1. 회사는 본 약관을 서비스 초기 화면 또는 연결 화면에 게시합니다.
2. 회사는 필요한 경우 관련 법령을 위반하지 않는 범위 내에서 본 약관을 개정할 수 있으며, 개정 시 최소 7일 전에 공지합니다.
3. 회원이 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 회원 탈퇴를 요청할 수 있습니다.

제4조(서비스의 제공)
1. 회사는 회원에게 다음 각 호의 서비스를 제공합니다.
  ① 중고 캠핑카 매물 등록/조회 서비스
  ② 채팅 및 메시지 서비스
  ③ 차량 정보, 시세, 리뷰 등 관련 콘텐츠 제공
  ④ 기타 회사가 정하는 부가 서비스
2. 회사는 서비스 개선을 위해 언제든지 콘텐츠, UI/UX 등을 변경할 수 있습니다.

제5조(회원의 의무)
1. 회원은 다음 행위를 해서는 안 됩니다.
  ① 허위 정보 등록 또는 타인의 정보를 도용하는 행위
  ② 법령 또는 본 약관에서 금지하는 행위
  ③ 서비스 운영을 방해하는 행위
2. 판매자는 등록한 매물에 대한 소유권, 상태, 사고 이력 등을 정확하게 제공해야 하며, 허위 정보를 제공할 경우 발생하는 문제에 대한 책임을 부담합니다.

제6조(거래에 대한 책임)
1. 회사는 거래 당사자 간의 매매 계약에 직접 관여하지 않습니다. 매물 검수, 대금 결제, 명의 이전 등은 당사자 책임으로 진행합니다.
2. 회사는 거래 과정에서 발생한 분쟁에 대해 법령이 허용하는 범위 내에서 책임을 부담하지 않습니다.

제7조(서비스 중단)
1. 회사는 시스템 점검, 보안 문제, 천재지변 등의 사유로 서비스 제공을 일시 중단할 수 있으며, 가능한 경우 사전 공지합니다.
2. 서비스 중단으로 회원에게 손해가 발생하더라도 회사의 고의 또는 중대한 과실이 없는 한 책임을 지지 않습니다.

제8조(지적재산권)
서비스에 게시된 콘텐츠, 상표, 로고 등은 회사 또는 해당 권리자의 자산이며, 무단 복제, 배포 등을 금지합니다.

제9조(책임 제한)
1. 회사는 회원 간의 거래로 인해 발생한 손해에 대해 책임을 지지 않습니다.
2. 회사의 책임은 법령이 허용하는 범위 내에서 최근 3개월 동안 회원이 회사에 지불한 금액을 한도로 합니다.

제10조(준거법 및 관할)
본 약관은 대한민국 법령에 따르며, 분쟁에 대해서는 민사소송법상의 관할 법원에 소송을 제기할 수 있습니다.

제11조(애플 앱스토어 관련 안내)
애플 앱스토어를 통해 서비스를 설치한 경우, 애플은 본 서비스의 거래 및 콘텐츠에 관한 어떠한 책임도 지지 않으며, 환불 및 고객 지원은 회사에서 제공합니다. 애플 기기 사용자는 애플의 이용 약관과 해당 국가의 법령을 준수해야 합니다.

부칙
본 약관은 2025년 9월 20일부터 시행합니다.
"""

    static let privacy = """
캠픽 개인정보 수집 및 이용 동의서

제1조(수집하는 개인정보 항목)
회사는 아래와 같은 개인정보를 수집합니다.
1. 필수 항목: 이름 또는 닉네임, 이메일 주소, 비밀번호, 휴대전화 번호, 지역(도/시·군·구)
2. 선택 항목: 프로필 사진, 매물 사진, 상세 설명에 포함된 연락처 등

제2조(개인정보의 수집 및 이용 목적)
회사는 다음과 같은 목적으로 개인정보를 이용합니다.
1. 회원 가입 및 본인 확인, 서비스 제공을 위한 기본 기능 제공
2. 매물 등록/관리, 거래 지원(연락, 채팅, 알림), 불법/부정 이용 방지
3. 고객 문의 응대, 공지사항 및 이벤트 안내
4. 서비스 품질 향상 및 통계 분석

제3조(개인정보의 보유 및 이용 기간)
1. 회원 탈퇴 시 즉시 파기합니다. 다만 관련 법령에 따라 보존할 필요가 있는 정보는 법정 기간 동안 보관합니다.
  - 전자상거래 등에서의 소비자 보호에 관한 법률: 계약 또는 청약철회 기록 5년, 대금 결제 및 재화 공급 기록 5년, 소비자 불만/분쟁 처리 기록 3년
  - 통신비밀보호법: 접속 기록 3개월

제4조(개인정보의 제3자 제공)
회사는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. 단, 법령에 근거한 요청이 있는 경우, 또는 사용자가 동의한 경우(예: 탁송/보험 서비스 연계)에는 예외로 합니다.

제5조(개인정보 처리의 위탁)
회사는 안정적인 서비스 제공을 위해 일부 업무를 외부 전문 업체에 위탁할 수 있으며, 위탁 시 개인정보 보호에 필요한 사항을 계약을 통해 규정합니다. 주요 위탁 업무 예: 클라우드 서버 운영, 푸시 알림, 데이터 분석.

제6조(이용자의 권리)
이용자는 언제든지 자신의 개인정보를 열람, 정정, 삭제, 처리 정지를 요청할 수 있으며, 동의를 철회할 수 있습니다. 다만, 필수 정보 삭제 시 서비스 이용이 제한될 수 있습니다.

제7조(개인정보의 파기)
개인정보는 수집 및 이용 목적이 달성된 후 지체 없이 파기합니다. 전자적 파일 형태로 저장된 정보는 복구 불가능한 방법으로 삭제하며, 종이 문서에 기록된 정보는 분쇄 또는 소각합니다.

제8조(안전성 확보 조치)
회사는 개인정보 유출 방지를 위해 암호화, 접근 통제, 침입 탐지 시스템 등을 운영하며, 정기적인 보안 점검을 수행합니다. 보안 사고 발생 시 관련 법령에 따라 신속히 통지합니다.

제9조(개인정보 보호 책임자)
성명: 캠픽 개인정보 보호 담당자
연락처: privacy@campick.com

제10조(정책 변경)
본 개인정보 처리방침은 법령이나 서비스 변경에 따라 수정될 수 있으며, 변경 사항은 사전에 공지합니다. 변경 이후에도 서비스를 계속 이용하는 경우 변경된 내용에 동의한 것으로 간주합니다.

본 동의서는 2025년 9월 20일부터 적용됩니다.
"""
}

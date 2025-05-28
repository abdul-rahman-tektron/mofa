import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/dashboard/dashboard_notifier.dart';
import 'package:mofa/utils/common/widgets/ticket_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardNotifier(context),
      child: Consumer<DashboardNotifier>(
        builder: (context, dashboardNotifier, child) {
          return buildBody(context, dashboardNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, DashboardNotifier dashboardNotifier) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          primary: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerText(context),
                10.verticalSpace,
                approvedPassCard(context, dashboardNotifier),
                15.verticalSpace,
                tabBar(context, dashboardNotifier),
                10.verticalSpace,
                tabBarView(context, dashboardNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerText(BuildContext context) {
    return Text(
      "Dashboard",
      // context.watchLang.translate(AppLanguageText.approvedPasses),
      style: AppFonts.textRegular24,
    );
  }

  Widget approvedPassCard(
    BuildContext context,
    DashboardNotifier dashboardNotifier,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 1.8, // Tune this based on card width/height
      ),
      itemCount: dashboardNotifier.cardData?.length ?? 0,
      itemBuilder: (context, index) {
        return buildPassCard(dashboardNotifier.cardData![index]);
      },
    );
  }

  Widget buildPassCard(DashboardCardData data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              data.icon,
              color: AppColors.textRedColor.withOpacity(0.2),
              size: 25,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.count.toString(), style: AppFonts.textRegular24),
                5.verticalSpace,
                Text(
                  data.title,
                  style: AppFonts.textRegular16,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      height: 45.h,
      padding: EdgeInsets.all(3), // space around the indicator
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.buttonBgColor, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.buttonBgColor,
        indicator: BoxDecoration(
          color: AppColors.buttonBgColor,
          borderRadius: BorderRadius.circular(30), // rounded indicator
        ),
        onTap: (index) {
          dashboardNotifier.selectedIndex = index;
          if (index == 0) {
            dashboardNotifier.isUpcoming = true;
            dashboardNotifier.apiGetAllExternalAppointment(
              context,
              dashboardNotifier.isUpcoming,
            );
          } else {
            dashboardNotifier.isUpcoming = false;
            dashboardNotifier.apiGetAllExternalAppointment(
              context,
              dashboardNotifier.isUpcoming,
            );
          }
        },
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppFonts.textBold14,
        unselectedLabelStyle: AppFonts.textBold14,
        tabs: const [Tab(text: 'Upcoming Visits'), Tab(text: 'Past Visits')],
      ),
    );
  }

  Widget tabBarView(BuildContext context, DashboardNotifier dashboardNotifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.minHeight),
          child: Column(
            children: [
              dashboardNotifier.selectedIndex == 0
                  ? buildAppointmentList(dashboardNotifier)
                  : buildAppointmentList(dashboardNotifier),
            ],
          ),
        );
      },
    );
  }

  Widget buildAppointmentList(DashboardNotifier dashboardNotifier) {
    final appointments =
        dashboardNotifier.isUpcoming
            ? dashboardNotifier.upcomingAppointments
            : dashboardNotifier.pastAppointments;

    if (appointments.isEmpty) {
      return Center(child: Column(
        children: [
          15.verticalSpace,
          Icon(LucideIcons.minusCircle, color: AppColors.primaryColor, size: 50),
          15.verticalSpace,
          Text('No Result found.', style: AppFonts.textRegular16),
        ],
      ));
    }

    return ListView.separated(
      itemCount: appointments.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => 15.verticalSpace,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return TicketCard(appointmentData: appointments[index]);
      },
    );
  }
}

class DashboardCardData {
  final IconData icon;
  final String title;
  final int count;

  DashboardCardData({
    required this.icon,
    required this.title,
    required this.count,
  });
}

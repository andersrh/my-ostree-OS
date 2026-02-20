Name:           xfce4-panel
Version:        4.20.0
Release:        1%{?dist}
Summary:        Next generation panel for the Xfce Desktop Environment

License:        GPLv2+ and LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfce4-panel/4.20/xfce4-panel-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  exo-devel >= 4.20.0
BuildRequires:  garcon-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libwnck3-devel
BuildRequires:  dbus-devel
BuildRequires:  dbus-glib-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
The Xfce Panel is part of the Xfce Desktop Environment and features
program launchers, panel menus, a clock, a desktop switcher and more.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang xfce4-panel

%files -f xfce4-panel.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-panel
%{_libdir}/libxfce4panel-2.0.so.*
%{_libdir}/xfce4/panel/
%{_datadir}/xfce4/panel/
%{_datadir}/icons/hicolor/*/apps/org.xfce.panel.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.panel.svg

%files devel
%{_includedir}/xfce4/libxfce4panel-2.0/
%{_libdir}/libxfce4panel-2.0.so
%{_libdir}/pkgconfig/libxfce4panel-2.0.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
